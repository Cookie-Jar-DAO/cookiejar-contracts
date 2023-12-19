// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";
import { CookieNFT } from "src/ERC6551/nft/CookieNFT.sol";
import { ImpCookieJar6551 } from "src/ERC6551/ImpCookieJar6551.sol";
import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { AccountRegistry } from "src/ERC6551/erc6551/ERC6551Registry.sol";

import { ZodiacBaalCookieJar } from "../src/SafeModule/BaalCookieJar.sol";
import { ZodiacERC20CookieJar } from "../src/SafeModule/ERC20CookieJar.sol";
import { ZodiacERC721CookieJar } from "../src/SafeModule/ERC721CookieJar.sol";
import { ZodiacListCookieJar } from "../src/SafeModule/ListCookieJar.sol";
import { ZodiacOpenCookieJar } from "../src/SafeModule/OpenCookieJar.sol";
import { CookieJarFactory } from "../src/factory/CookieJarFactory.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";
import { ModuleProxyFactory } from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";

//import forge console
import { console } from "forge-std/console.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract TestMintCookieJar is Script {
    address internal deployer;
    uint256 internal deployerPk;

    // Zodiac
    address internal baalCookieJar = 0x2bfe504e5C145F5d5b95df2b7798Ec1C422C5Bc1;
    address internal erc20CookieJar = 0x8e694435C2Ad04ac4C59F50d75D501f678aD26bd;
    address internal erc721CookieJar = 0x24A2D8772521A9fa2f85d7024e020e7821C23c97;
    address internal listCookieJar = 0x3Ae8da051CC6Ab7Ef884A8f0fF86e02c3303fc38;
    address internal openCookieJar = 0x0c6544Af9424C24549c57BD805C299635081eDE4;
    address internal cookieJarFactory = 0x3737053eC30f53DD7543a615dA69BB9996aD7C81;
    address internal moduleProxyFactory;

    // 6551
    address internal listCookieJar6551 = 0x3Ae8da051CC6Ab7Ef884A8f0fF86e02c3303fc38;
    address internal accountImp = 0x9CD838ba5ce219d1Eaf58Fa413b9D6e74799A7c8;
    address internal nft = 0x65022ba0CD19699D84A32945c710519c82b6597B;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        if (bytes(mnemonic).length > 0) {
            (deployer,) = deriveRememberKey(mnemonic, 0);
        } else {
            deployerPk = vm.envUint("PRIVATE_KEY");
        }
        if (block.chainid == 10) moduleProxyFactory = 0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC;
        if (block.chainid == 31_337) moduleProxyFactory = address(new ModuleProxyFactory());
        else moduleProxyFactory = 0x00000000000DC7F163742Eb4aBEf650037b1f588;
    }

    function run() public {
        if (deployer != address(0)) vm.startBroadcast(deployer);
        else vm.startBroadcast(deployerPk);

        address user1 = vm.addr(1);
        uint256 cookieAmount = 1e16;
        uint256 periodLength = 3600;
        address cookieToken = address(listCookieJar6551);
        address[] memory allowList = new address[](0);
        string memory details = "details";

        CookieNFT(nft).cookieMint(user1, periodLength, cookieAmount, cookieToken, address(0), 0, allowList, details);

        vm.stopBroadcast();
    }
}
