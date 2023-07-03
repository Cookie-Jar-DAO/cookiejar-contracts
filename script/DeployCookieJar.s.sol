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
contract DeployCookieJar is Script {
    address internal deployer;
    uint256 internal deployerPk;

    // Zodiac
    address internal baalCookieJar;
    address internal erc20CookieJar;
    address internal erc721CookieJar;
    address internal listCookieJar;
    address internal openCookieJar;
    address internal cookieJarFactory;
    address internal safeModuleSummoner;
    address internal moduleProxyFactory;

    // 6551
    address internal listCookieJar6551;
    address internal accountImp;
    address internal registry = 0x02101dfB77FDE026414827Fdc604ddAF224F0921;
    address internal nft;

    function setUp() public virtual {
        // string memory mnemonic = vm.envString("MNEMONIC");
        // if (bytes(mnemonic).length > 0) {
        //     console.log("Using mnemonic");

        //     (deployer,) = deriveRememberKey(mnemonic, 0);
        // } else {
        console.log("Using private key");

        deployerPk = vm.envUint("PRIVATE_KEY");
        // }
        // Optimism
        if (block.chainid == 10) moduleProxyFactory = 0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC;

        // Hardhat
        if (block.chainid == 31_337) moduleProxyFactory = address(new ModuleProxyFactory());
        // Default
        else moduleProxyFactory = 0x00000000000DC7F163742Eb4aBEf650037b1f588;
    }

    function run() public {
        console.log('"deployer": "%s",', deployer);

        if (deployer != address(0)) vm.startBroadcast(deployer);
        else vm.startBroadcast(deployerPk);

        // Zodiac
        baalCookieJar = address(new ZodiacBaalCookieJar());
        erc20CookieJar = address(new ZodiacERC20CookieJar());
        erc721CookieJar = address(new ZodiacERC721CookieJar());
        listCookieJar = address(new ZodiacListCookieJar());
        openCookieJar = address(new ZodiacOpenCookieJar());
        cookieJarFactory = address(new CookieJarFactory());
        CookieJarFactory(cookieJarFactory).setProxyFactory(moduleProxyFactory);

        // 6551

        listCookieJar6551 = address(new ImpCookieJar6551());
        accountImp = address(new AccountERC6551());
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
        console.log('"baalCookieJar": "%s",', baalCookieJar);
        console.log('"erc20CookieJar": "%s",', erc20CookieJar);
        console.log('"erc721CookieJar": "%s",', erc721CookieJar);
        console.log('"listCookieJar": "%s",', listCookieJar);
        console.log('"openCookieJar": "%s",', openCookieJar);
        console.log('"cookieJarFactory": "%s",', cookieJarFactory);
        console.log('"listCookieJar6551": "%s",', listCookieJar);
        console.log('"account": "%s",', accountImp);
        console.log('"registry": "%s",', registry);
        console.log('"nft": "%s",', nft);
        // solhint-enable quotes

        vm.stopBroadcast();
    }
}
