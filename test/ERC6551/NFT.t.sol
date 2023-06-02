// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {AccountRegistry} from "src/ERC6551/erc6551/ERC6551Registry.sol";
import {IRegistry} from "src/interfaces/IERC6551Registry.sol";
import {AccountERC6551} from "src/ERC6551/erc6551/ERC6551Module.sol";
import {MinimalReceiver} from "src/lib/MinimalReceiver.sol";

import {CookieNFT} from "src/ERC6551/nft/CookieNFT.sol";
import {CookieJarCore} from "src/core/CookieJarCore.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {ImpCookieJar6551} from "src/ERC6551/ImpCookieJar6551.sol";

import {ModuleProxyFactory} from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";

contract AccountRegistryTest is PRBTest {
    AccountERC6551 public implementation;
    AccountRegistry public accountRegistry;

    CookieJarCore public cookieJarImp;
    CookieJarFactory public cookieJarSummoner;
    ImpCookieJar6551 public listCookieJarImp;
    CookieNFT public tokenCollection;

    ModuleProxyFactory public moduleProxyFactory;

    function setUp() public {
        implementation = new AccountERC6551();
        accountRegistry = new AccountRegistry();

        cookieJarSummoner = new CookieJarFactory();
        listCookieJarImp = new ImpCookieJar6551();

        moduleProxyFactory = new ModuleProxyFactory();

        cookieJarSummoner.setProxyFactory(address(moduleProxyFactory));

        tokenCollection = new CookieNFT(
            address(accountRegistry),
            address(implementation),
            address(cookieJarSummoner),
            address(listCookieJarImp)
        );

        vm.mockCall(
            0x000000000000cd17345801aa8147b8D3950260FF,
            abi.encodeWithSelector(IPoster.post.selector),
            ""
        );
    }

    function testCookieMint()
        public
        returns (address account, address cookieJar, uint256 tokenId)
    {
        address user1 = vm.addr(1);
        uint256 cookieAmount = 1e16;
        uint256 periodLength = 3600;
        address cookieToken = address(cookieJarImp);
        address[] memory allowList = new address[](0);

        (account, cookieJar, tokenId) = tokenCollection.cookieMint(
            user1,
            periodLength,
            cookieAmount,
            cookieToken,
            allowList
        );

        (bool sent, ) = payable(account).call{value: 1 ether}("");
        require(sent, "Failed to send Ether?");

        assertEq(tokenCollection.balanceOf(user1), 1);
    }

    function testCookieAddAccountToAllowListAsOwner() public {
        (address account, address cookieJar, ) = testCookieMint();
        AccountERC6551 accountContract = AccountERC6551(payable(account));
        ImpCookieJar6551 listCookieJarContract = ImpCookieJar6551(cookieJar);

        vm.prank(vm.addr(1));
        accountContract.executeCall(
            cookieJar,
            0,
            abi.encodeWithSelector(
                listCookieJarContract.setAllowList.selector,
                vm.addr(2),
                true
            )
        );

        assertEq(listCookieJarContract.allowList(vm.addr(2)), true);
    }

    function testCookieRemoveAccountToAllowListAsOwner() public {
        (address account, address cookieJar, ) = testCookieMint();
        AccountERC6551 accountContract = AccountERC6551(payable(account));
        ImpCookieJar6551 listCookieJarContract = ImpCookieJar6551(cookieJar);

        vm.prank(vm.addr(1));
        accountContract.executeCall(
            cookieJar,
            0,
            abi.encodeWithSelector(
                listCookieJarContract.setAllowList.selector,
                vm.addr(2),
                true
            )
        );
        vm.prank(vm.addr(1));
        accountContract.executeCall(
            cookieJar,
            0,
            abi.encodeWithSelector(
                listCookieJarContract.setAllowList.selector,
                vm.addr(2),
                false
            )
        );
        assertEq(listCookieJarContract.allowList(vm.addr(2)), false);
    }

    function testCookieAllowListWithdraw() public {
        (address account, address cookieJar, ) = testCookieMint();
        AccountERC6551 accountContract = AccountERC6551(payable(account));
        ImpCookieJar6551 listCookieJarContract = ImpCookieJar6551(cookieJar);

        vm.prank(vm.addr(1));
        accountContract.executeCall(
            cookieJar,
            0,
            abi.encodeWithSelector(
                listCookieJarContract.setAllowList.selector,
                vm.addr(2),
                true
            )
        );
        assertEq(listCookieJarContract.allowList(vm.addr(2)), true);

        vm.prank(vm.addr(2));
        ImpCookieJar6551(cookieJar).reachInJar(vm.addr(2), "test");
        // new balance should be 1 eth minus cookie amount
        assertEq(account.balance, 1e18 - 1e16);
    }

    function testCookieNftTransfer() public {
        (
            address account,
            address cookieJar,
            uint256 tokenId
        ) = testCookieMint();
        vm.prank(vm.addr(1));
        tokenCollection.transferFrom(vm.addr(1), vm.addr(2), tokenId);
        assertEq(tokenCollection.balanceOf(vm.addr(2)), 1);
        assertEq(tokenCollection.balanceOf(vm.addr(1)), 0);

        AccountERC6551 accountContract = AccountERC6551(payable(account));
        ImpCookieJar6551 listCookieJarContract = ImpCookieJar6551(cookieJar);

        vm.prank(vm.addr(1));
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        accountContract.executeCall(
            cookieJar,
            0,
            abi.encodeWithSelector(
                listCookieJarContract.setAllowList.selector,
                vm.addr(2),
                true
            )
        );
    }

    function testCookieNftTokenURI() public {
        (
            ,
            ,
            uint256 tokenId
        ) = testCookieMint();

        tokenCollection.tokenURI(tokenId);

    }
}
