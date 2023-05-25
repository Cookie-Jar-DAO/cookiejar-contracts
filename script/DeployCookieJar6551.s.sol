// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19;

import { Script } from "forge-std/Script.sol";

import { CookieJarFactory } from "src/factory/CookieJarFactory.sol";
import { CookieNFT } from "src/ERC6551/nft/CookieNFT.sol";
import { ListCookieJar6551 } from "src/ERC6551/ListCookieJar6551.sol";

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { AccountRegistry } from "src/ERC6551/erc6551/ERC6551Registry.sol";

import { Create2 } from "@openzeppelin/contracts/utils/Create2.sol";

//import forge console
import { console } from "forge-std/console.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployCookieJar6551 is Script {
    address internal deployer;

    address internal listCookieJar;

    address internal cookieJarFactory;
    address internal accountImp;
    address internal registry;
    address internal nft;

    function setUp() public virtual {
        string memory mnemonic = vm.envString("MNEMONIC");
        (deployer,) = deriveRememberKey(mnemonic, 0);
    }

    function run() public {
        vm.startBroadcast(deployer);

        listCookieJar = address(new ListCookieJar6551());

        cookieJarFactory = address(new CookieJarFactory());

        accountImp = address(new AccountERC6551());
        registry = address(new AccountRegistry(accountImp));

        nft = address(
            new CookieNFT(
            registry, // account registry
            accountImp,
            cookieJarFactory,
            listCookieJar
            )
        );
        // solhint-disable quotes

        console.log('"listCookieJar imp": "%s",', listCookieJar);
        console.log('"cookieJarFactory": "%s",', cookieJarFactory);
        console.log('"account Imp": "%s",', accountImp);
        console.log('"nft": "%s",', nft);

        // solhint-enable quotes

        vm.stopBroadcast();
    }
}
