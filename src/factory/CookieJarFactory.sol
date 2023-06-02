// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ModuleProxyFactory} from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {CookieJarCore} from "src/core/CookieJarCore.sol";

contract CookieJarFactory is Ownable {
    ModuleProxyFactory internal moduleProxyFactory;

    event SummonCookieJar(address cookieJar, bytes initializer, string details);

    /*solhint-disable no-empty-blocks*/
    constructor() {}

    // must be called after deploy to set libraries
    function setProxyFactory(address _moduleProxyFactory) public onlyOwner {
        moduleProxyFactory = ModuleProxyFactory(_moduleProxyFactory);
    }

    //Cookie Jar init params
    // 0. address safeAddress
    // 1. uint256 _periodLength,
    // 2. uint256 _cookieAmount,
    // 3. address _cookieToken

    // Baal
    // 4. address _dao,
    // 5. uint256 _threshold,
    // 6. bool _useShares,
    // 7. bool _useLoot

    // ERC20
    // 4. address _erc20addr,
    // 5. uint256 _threshold

    // ERC721
    // 4. address _erc721addr,
    // 5. uint256 _threshold

    // Mapping
    // 4. address[] _allowlist

    // TODO: not used by NFT anymore, we can probably get rid of it
    function summonCookieJar(address _singleton, bytes memory _initializer, string memory _details)
        public
        returns (address)
    {
        //TODO CookieJarCore can be an interface?
        CookieJarCore cookieJar = CookieJarCore(Clones.clone(_singleton));
        cookieJar.setUp(_initializer);


        emit SummonCookieJar(address(cookieJar), _initializer, _details);

        //TODO do we need to return the address?
        return address(cookieJar);
    }

    function summonCookieJar(address _singleton, bytes memory _initializer, string memory _details, uint256 _saltNonce)
        public
        returns (address)

    {
        CookieJarCore cookieJar = CookieJarCore(moduleProxyFactory.deployModule(_singleton, _initializer, _saltNonce));

        emit SummonCookieJar(address(cookieJar), _initializer, _details);
        return address(cookieJar);

    }
}
