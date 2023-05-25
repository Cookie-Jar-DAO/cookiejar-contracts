// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {IRegistry} from "src/interfaces/IERC6551Registry.sol";
import {AccountRegistry} from "src/ERC6551/erc6551/ERC6551Registry.sol";
import {AccountERC6551} from "src/ERC6551/erc6551/ERC6551Module.sol";
import {MinimalReceiver} from "src/lib/MinimalReceiver.sol";

contract AccountRegistryTest is PRBTest {
    AccountERC6551 implementation;
    AccountRegistry public accountRegistry;

    event AccountCreated(
        address account,
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt
    );

    function setUp() public {
        implementation = new AccountERC6551();
        accountRegistry = new AccountRegistry();
    }

    function testDeployAccount(
        address tokenCollection,
        uint256 tokenId
    ) public {
        assertTrue(address(accountRegistry) != address(0));

        address predictedAccountAddress = accountRegistry.account(
            address(implementation),
            block.chainid,
            tokenCollection,
            tokenId,
            101
        );

        vm.expectEmit(true, true, true, true);
        emit AccountCreated(
            predictedAccountAddress,
            address(implementation),
            block.chainid,
            tokenCollection,
            tokenId,
            101
        );
        address accountAddress = accountRegistry.createAccount(
            address(implementation),
            block.chainid,
            tokenCollection,
            tokenId,
            101,
            ""
        );

        assertTrue(accountAddress != address(0));
        assertTrue(accountAddress == predictedAccountAddress);
    }
}
