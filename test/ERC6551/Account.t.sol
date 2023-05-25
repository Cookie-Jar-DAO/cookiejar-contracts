// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/interfaces/IERC1271.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {AccountERC6551} from "src/ERC6551/erc6551/ERC6551Module.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {AccountRegistry} from "src/ERC6551/erc6551/ERC6551Registry.sol";
import {IRegistry} from "src/interfaces/IERC6551Registry.sol";
import {MinimalReceiver} from "src/lib/MinimalReceiver.sol";
import {MinimalProxyStore} from "src/lib/MinimalProxyStore.sol";

import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";

import {MockExecutor} from "test/utils/MockExecutor.sol";

import {MockReverter} from "test/utils/MockReverter.sol";

import {MockERC721} from "test/utils/MockERC721.sol";

import {IAccount} from "src/interfaces/IERC6551.sol";

import "forge-std/console.sol";

contract AccountTest is PRBTest {
    AccountERC6551 public implementation;
    AccountRegistry public accountRegistry;

    MockERC721 public tokenCollection;

    function setUp() public {
        implementation = new AccountERC6551();
        accountRegistry = new AccountRegistry(address(implementation));
        tokenCollection = new MockERC721();
    }

    function testNonOwnerCallsFail(uint256 tokenId) public {
        address user1 = vm.addr(1);
        address user2 = vm.addr(2);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        // should fail if user2 tries to use account
        vm.prank(user2);
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        account.executeCall(payable(user2), 0.1 ether, "");

        // should fail if user2 tries to set executor
        vm.prank(user2);
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        account.setExecutor(vm.addr(1337));

        // should fail if user2 tries to lock account
        vm.prank(user2);
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        account.lock(364 days);
    }

    function testAccountOwnershipTransfer(uint256 tokenId) public {
        address user1 = vm.addr(1);
        address user2 = vm.addr(2);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        // should fail if user2 tries to use account
        vm.prank(user2);
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        account.executeCall(payable(user2), 0.1 ether, "");

        vm.prank(user1);
        tokenCollection.safeTransferFrom(user1, user2, tokenId);

        // should succeed now that user2 is owner
        vm.prank(user2);
        account.executeCall(payable(user2), 0.1 ether, "");

        assertEq(user2.balance, 0.1 ether);
    }

    function testMessageVerification(uint256 tokenId) public {
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        bytes32 hash = keccak256("This is a signed message");
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(1, hash);

        bytes memory signature1 = abi.encodePacked(r1, s1, v1);

        bytes4 returnValue1 = account.isValidSignature(hash, signature1);

        assertEq(returnValue1, IERC1271.isValidSignature.selector);
    }

    function testMessageVerificationForUnauthorizedUser(uint256 tokenId) public {
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        bytes32 hash = keccak256("This is a signed message");

        (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(2, hash);
        bytes memory signature2 = abi.encodePacked(r2, s2, v2);

        bytes4 returnValue2 = account.isValidSignature(hash, signature2);

        assertEq(returnValue2, 0);
    }

    function testAccountLocksAndUnlocks(uint256 tokenId) public {
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        // cannot be locked for more than 365 days
        vm.prank(user1);
        vm.expectRevert(AccountERC6551.ExceedsMaxLockTime.selector);
        account.lock(block.timestamp + 366 days); // todo added block.timestamp + 366 days

        // lock account for 10 days
        uint256 unlockTimestamp = block.timestamp + 10 days;
        vm.prank(user1);
        account.lock(unlockTimestamp);

        assertEq(account.isLocked(), true);

        // transaction should revert if account is locked
        vm.prank(user1);
        vm.expectRevert(AccountERC6551.AccountLocked.selector);
        account.executeCall(payable(user1), 1 ether, "");

        // fallback calls should revert if account is locked
        vm.prank(user1);
        vm.expectRevert(AccountERC6551.AccountLocked.selector);
        (bool success, bytes memory result) = accountAddress.call(abi.encodeWithSignature("customFunction()"));

        // silence unused variable compiler warnings
        success;
        result;

        // setExecutor calls should revert if account is locked
        vm.prank(user1);
        vm.expectRevert(AccountERC6551.AccountLocked.selector);
        account.setExecutor(vm.addr(1337));

        // lock calls should revert if account is locked
        vm.prank(user1);
        vm.expectRevert(AccountERC6551.AccountLocked.selector);
        account.lock(0);

        // signing should fail if account is locked
        bytes32 hash = keccak256("This is a signed message");
        (uint8 v1, bytes32 r1, bytes32 s1) = vm.sign(2, hash);
        bytes memory signature1 = abi.encodePacked(r1, s1, v1);
        bytes4 returnValue = account.isValidSignature(hash, signature1);
        assertEq(returnValue, 0);

        // warp to timestamp after account is unlocked
        vm.warp(unlockTimestamp + 1 days);

        // transaction succeed now that account lock has expired
        vm.prank(user1);
        account.executeCall(payable(user1), 1 ether, "");
        assertEq(user1.balance, 1 ether);

        // signing should now that account lock has expired
        bytes32 hashAfterUnlock = keccak256("This is a signed message");
        (uint8 v2, bytes32 r2, bytes32 s2) = vm.sign(1, hashAfterUnlock);
        bytes memory signature2 = abi.encodePacked(r2, s2, v2);
        bytes4 returnValue1 = account.isValidSignature(hashAfterUnlock, signature2);
        assertEq(returnValue1, IERC1271.isValidSignature.selector);
    }

    function testCustomExecutorFallback(uint256 tokenId) public {
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        MockExecutor mockExecutor = new MockExecutor();

        // calls succeed with noop if executor is undefined
        (bool success, bytes memory result) = accountAddress.call(abi.encodeWithSignature("customFunction()"));
        assertEq(success, true);
        assertEq(result, "");

        // calls succeed with noop if executor is EOA
        vm.prank(user1);
        account.setExecutor(vm.addr(1337));
        (bool success1, bytes memory result1) = accountAddress.call(abi.encodeWithSignature("customFunction()"));
        assertEq(success1, true);
        assertEq(result1, "");

        assertEq(account.isAuthorized(user1), true);
        assertEq(account.isAuthorized(address(mockExecutor)), false);

        vm.prank(user1);
        account.setExecutor(address(mockExecutor));

        assertEq(account.isAuthorized(user1), true);
        assertEq(account.isAuthorized(address(mockExecutor)), true);

        assertEq(account.isValidSignature(bytes32(0), ""), IERC1271.isValidSignature.selector);

        // execution module handles fallback calls
        assertEq(MockExecutor(accountAddress).customFunction(), 12_345);

        // execution bubbles up errors on revert
        vm.expectRevert(MockReverter.MockError.selector);
        MockExecutor(accountAddress).fail();
    }

    function testCustomExecutorCalls(uint256 tokenId) public {
        address user1 = vm.addr(1);
        address user2 = vm.addr(2);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        assertEq(account.isAuthorized(user2), false);

        vm.prank(user1);
        account.setExecutor(user2);

        assertEq(account.isAuthorized(user2), true);

        vm.prank(user2);
        account.executeTrustedCall(user2, 0.1 ether, "");

        assertEq(user2.balance, 0.1 ether);
    }

    function testExecuteCallRevert(uint256 tokenId) public {
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        MockReverter mockReverter = new MockReverter();

        vm.prank(user1);
        vm.expectRevert(MockReverter.MockError.selector);
        account.executeCall(payable(address(mockReverter)), 0, abi.encodeWithSignature("fail()"));
    }

    function testAccountOwnerIsNullIfContextNotSet() public {
        address accountClone = Clones.clone(accountRegistry.implementation());

        assertEq(AccountERC6551(payable(accountClone)).owner(), address(0));
    }

    function testEIP165Support() public {
        uint256 tokenId = 1;
        address user1 = vm.addr(1);

        tokenCollection.mint(user1, tokenId);
        assertEq(tokenCollection.ownerOf(tokenId), user1);

        address accountAddress = accountRegistry.createAccount(address(tokenCollection), tokenId);

        vm.deal(accountAddress, 1 ether);

        AccountERC6551 account = AccountERC6551(payable(accountAddress));

        assertEq(account.supportsInterface(type(IAccount).interfaceId), true);
        assertEq(account.supportsInterface(type(IERC1155Receiver).interfaceId), true);
        assertEq(account.supportsInterface(type(IERC165).interfaceId), true);
        assertEq(account.supportsInterface(IERC1271.isValidSignature.selector), false);

        MockExecutor mockExecutor = new MockExecutor();

        vm.prank(user1);
        account.setExecutor(address(mockExecutor));

        assertEq(account.supportsInterface(IERC1271.isValidSignature.selector), true);
    }
}
