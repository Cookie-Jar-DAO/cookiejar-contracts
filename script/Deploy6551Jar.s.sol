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
contract Deploy6551Jar is Script {
    address internal deployer;
    uint256 internal deployerPk;

    // Zodiac
    address internal moduleProxyFactory;

    // 6551
    address internal nft;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        if (bytes(mnemonic).length > 0) {
            console.log("Using mnemonic");

            (deployer,) = deriveRememberKey(mnemonic, 0);
        } else {
            console.log("Using private key");

            deployerPk = vm.envUint("PRIVATE_KEY");
        }

        // Optimism
        if (block.chainid == 10) moduleProxyFactory = 0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC;

        // Hardhat
        if (block.chainid == 31_337) moduleProxyFactory = address(new ModuleProxyFactory());
        // Default
        else moduleProxyFactory = 0x00000000000DC7F163742Eb4aBEf650037b1f588;
    }

    function run() public {
        // console.log('"deployer": "%s",', deployer);

        // if (deployer != address(0)) vm.startBroadcast(deployer);
        // else

        console.log('"deployerBalance": "%s",', address(deployer).balance);

        vm.startBroadcast(deployer);

        // // 6551
        address registry = 0x02101dfB77FDE026414827Fdc604ddAF224F0921;
        address cookieJarFactory = 0xD8f6FE1E102a05Eae8ab70290Dc410f80FdA3a8D;
        address listCookieJar6551 = address(new ImpCookieJar6551());
        address accountImp = 0x75f88208b6DcCa2Beb069ED38A403956f9cd1095;

        nft = address(
            new CookieNFT(
            registry, // account registry
            accountImp,
            cookieJarFactory,
            listCookieJar6551
            )
        );

        // solhint-disable quotes
        console.log(block.chainid);
        console.log('"listCookieJar6551": "%s",', listCookieJar6551);
        console.log('"account": "%s",', accountImp);
        console.log('"registry": "%s",', registry);
        console.log('"nft": "%s",', nft);
        // solhint-enable quotes

        vm.stopBroadcast();
    }
}
