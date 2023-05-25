// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";
import { ZodiacBaalCookieJar } from "../src/SafeModule/BaalCookieJar.sol";
import { ZodiacERC20CookieJar } from "../src/SafeModule/ERC20CookieJar.sol";
import { ZodiacERC721CookieJar } from "../src/SafeModule/ERC721CookieJar.sol";
import { ZodiacListCookieJar } from "../src/SafeModule/ListCookieJar.sol";
import { ZodiacOpenCookieJar } from "../src/SafeModule/OpenCookieJar.sol";
import { CookieJarFactory } from "../src/factory/CookieJarFactory.sol";
import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";

//import forge console
import { console } from "forge-std/console.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployCookieJar is Script {
    address internal deployer;
    uint256 internal deployerPk;
    address internal baalCookieJar;
    address internal erc20CookieJar;
    address internal erc721CookieJar;
    address internal listCookieJar;
    address internal openCookieJar;
    address internal cookieJarFactory;
    address internal safeModuleSummoner;
    address internal moduleProxyFactory;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        if (bytes(mnemonic).length > 0) {
            (deployer,) = deriveRememberKey(mnemonic, 0);
        } else {
            deployerPk = vm.envUint("PRIVATE_KEY");
        }
        if (block.chainid == 10) moduleProxyFactory = 0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC;
        else moduleProxyFactory = 0x00000000000DC7F163742Eb4aBEf650037b1f588;
    }

    function run() public {
        if (deployer != address(0)) vm.startBroadcast(deployer);
        else vm.startBroadcast(deployerPk);

        baalCookieJar = address(new ZodiacBaalCookieJar());
        erc20CookieJar = address(new ZodiacERC20CookieJar());
        erc721CookieJar = address(new ZodiacERC721CookieJar());
        listCookieJar = address(new ZodiacListCookieJar());
        openCookieJar = address(new ZodiacOpenCookieJar());
        cookieJarFactory = address(new CookieJarFactory());
        // moduleSummoner.setAddrs(moduleProxyFactory);
        // safeModuleSummoner = address(moduleSummoner);

        // solhint-disable quotes
        console.log('"baalCookieJar": "%s",', baalCookieJar);
        console.log('"erc20CookieJar": "%s",', erc20CookieJar);
        console.log('"erc721CookieJar": "%s",', erc721CookieJar);
        console.log('"listCookieJar": "%s",', listCookieJar);
        console.log('"openCookieJar": "%s",', openCookieJar);
        console.log('"cookieJarFactory": "%s",', cookieJarFactory);
        console.log('"safeModuleSummoner": "%s",', safeModuleSummoner);
        // solhint-enable quotes

        vm.stopBroadcast();
    }
}
