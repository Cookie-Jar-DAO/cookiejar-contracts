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
contract DeployNFT is Script {
    address internal deployer;
    uint256 internal deployerPk;

    // Zodiac
    address internal cookieJarFactory = 0x3737053eC30f53DD7543a615dA69BB9996aD7C81;

    // 6551
    address internal listCookieJar6551 = 0x81eF83E26a19C0532a0DF80D84525bfCaCF2E4C4;
    address internal accountImp = 0x9CD838ba5ce219d1Eaf58Fa413b9D6e74799A7c8;
    address internal registry = 0xa5a306b95B36d17C6711679b0E9758632083B8B0;
    address internal nft;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        if (bytes(mnemonic).length > 0) {
            (deployer,) = deriveRememberKey(mnemonic, 0);
        } else {
            deployerPk = vm.envUint("PRIVATE_KEY");
        }
    }

    function run() public {
        if (deployer != address(0)) vm.startBroadcast(deployer);
        else vm.startBroadcast(deployerPk);

        // 6551
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
        console.log('"nft": "%s",', nft);
        // solhint-enable quotes

        vm.stopBroadcast();
    }
}
