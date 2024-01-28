// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import { AccountRegistry } from "src/ERC6551/erc6551/ERC6551Registry.sol";
import { IRegistry } from "src/interfaces/IERC6551Registry.sol";
import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { MinimalReceiver } from "src/lib/MinimalReceiver.sol";

import { CookieNFT } from "src/ERC6551/nft/CookieNFT.sol";
import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { CookieJarFactory } from "src/factory/CookieJarFactory.sol";

import { ModuleProxyFactory } from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";

import { BaalCookieJar6551 } from "src/ERC6551/BaalCookieJar6551.sol";
import { ERC20CookieJar6551 } from "src/ERC6551/ERC20CookieJar6551.sol";
import { ERC721CookieJar6551 } from "src/ERC6551/ERC721CookieJar6551.sol";
import { ListCookieJar6551 } from "src/ERC6551/ListCookieJar6551.sol";
import { OpenCookieJar6551 } from "src/ERC6551/OpenCookieJar6551.sol";

contract CookieNFTTest is PRBTest, StdCheats {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal owner = makeAddr("owner");

    AccountERC6551 public implementation;
    AccountRegistry public accountRegistry;

    CookieJarCore public cookieJarImp;
    CookieJarFactory public cookieJarSummoner;
    CookieNFT public cookieJarNFT;

    BaalCookieJar6551 public baalCookieJarImp;
    ERC20CookieJar6551 public erc20CookieJarImp;
    ERC721CookieJar6551 public erc721CookieJarImp;
    ListCookieJar6551 public listCookieJarImp;
    OpenCookieJar6551 public openCookieJarImp;

    ModuleProxyFactory public moduleProxyFactory;

    function setUp() public {
        implementation = new AccountERC6551();
        accountRegistry = new AccountRegistry();

        cookieJarSummoner = new CookieJarFactory(owner);

        baalCookieJarImp = new BaalCookieJar6551();
        erc20CookieJarImp = new ERC20CookieJar6551();
        erc721CookieJarImp = new ERC721CookieJar6551();
        listCookieJarImp = new ListCookieJar6551();
        openCookieJarImp = new OpenCookieJar6551();

        moduleProxyFactory = new ModuleProxyFactory();

        vm.prank(owner);
        cookieJarSummoner.setProxyFactory(address(moduleProxyFactory));

        cookieJarNFT = new CookieNFT(address(accountRegistry), address(implementation), address(cookieJarSummoner));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testCookieMint() public returns (address account, address cookieJar, uint256 tokenId) {
        uint256 cookieAmount = 1e16;
        uint256 periodLength = 3600;
        address cookieToken = address(cookieJarImp);
        address[] memory allowList = new address[](0);
        string memory details =
            "{\"type\":\"List\",\"name\":\"Moloch Pastries\",\"description\":\"This is where you add some more content\",\"link\":\"app.daohaus.club/0x64/0x0....666\"}";

        bytes memory _initializer = abi.encode(alice, periodLength, cookieAmount, cookieToken, allowList);
        (account, cookieJar, tokenId) =
            cookieJarNFT.cookieMint(address(listCookieJarImp), _initializer, details, address(0), 0);

        (bool sent,) = payable(account).call{ value: 1 ether }("");
        require(sent, "Failed to send Ether?");

        assertEq(cookieJarNFT.balanceOf(alice), 1);
    }

    function testCookieNftTransfer() public {
        (address account, address cookieJar, uint256 tokenId) = testCookieMint();
        vm.prank(alice);
        cookieJarNFT.transferFrom(alice, bob, tokenId);
        assertEq(cookieJarNFT.balanceOf(bob), 1);
        assertEq(cookieJarNFT.balanceOf(alice), 0);

        AccountERC6551 accountContract = AccountERC6551(payable(account));
        ListCookieJar6551 listCookieJarContract = ListCookieJar6551(cookieJar);

        vm.prank(alice);
        vm.expectRevert(AccountERC6551.NotAuthorized.selector);
        accountContract.executeCall(
            cookieJar, 0, abi.encodeWithSelector(listCookieJarContract.setAllowList.selector, bob, true)
        );
    }

    function testCookieNftTokenURI() public {
        (,, uint256 tokenId) = testCookieMint();

        cookieJarNFT.tokenURI(tokenId);
    }

    function testCookieNftBurn() public {
        (,, uint256 tokenId) = testCookieMint();

        vm.expectRevert("ERC721: caller is not token owner or approved");
        cookieJarNFT.burn(tokenId);

        vm.prank(alice);
        cookieJarNFT.burn(tokenId);
    }
}
