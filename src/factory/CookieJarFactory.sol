// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import {ModuleProxyFactory} from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {CookieJarCore} from "src/core/CookieJarCore.sol";
import {CookieUtils} from "src/lib/CookieUtils.sol";

contract CookieJarFactory is Ownable {
    ModuleProxyFactory internal moduleProxyFactory;

    event SummonCookieJar(address cookieJar, bytes initializer, string details, string uid);

    /*solhint-disable no-empty-blocks*/
    constructor() {}

    // must be called after deploy to set libraries
    function setProxyFactory(address _moduleProxyFactory) public onlyOwner {
        moduleProxyFactory = ModuleProxyFactory(_moduleProxyFactory);
    }

    //Cookie Jar init params
    // 0. address owner or safeTarget,
    // 2. uint256 _periodLength,
    // 3. uint256 _cookieAmount,
    // 4. address _cookieToken

    // Baal
    // 5. address _dao,
    // 6. uint256 _threshold,
    // 7. bool _useShares,
    // 8. bool _useLoot

    // ERC20
    // 7. address _erc20addr,
    // 8. uint256 _threshold

    // ERC721
    // 7. address _erc721addr,
    // 8. uint256 _threshold

    // Mapping
    // 7. address[] _allowlist

    // Details
    // {
    //   "type":"Baal",
    //   "name":"Moloch Pastries",
    //   "description":"This is where you add some more content",
    //   "link":"app.daohaus.club/0x64/0x0....666"
    // }

    function summonCookieJar(address _singleton, bytes memory _initializer, string memory _details, uint256 _saltNonce)
        public
        returns (address)
    {
        CookieJarCore cookieJar = CookieJarCore(moduleProxyFactory.deployModule(_singleton, _initializer, _saltNonce));

        string memory uid = CookieUtils.getCookieJarUid(address(cookieJar));

        emit SummonCookieJar(address(cookieJar), _initializer, _details, uid);
        return address(cookieJar);
    }
}
