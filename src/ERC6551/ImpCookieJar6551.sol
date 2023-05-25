// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {CookieJarCore} from "src/core/CookieJarCore.sol";
import {Giver6551} from "src/core/givers/Giver6551.sol";

contract ImpCookieJar6551 is CookieJarCore, Giver6551 {
    mapping(address allowed => bool isAllowed) public allowList;

    function setUp(
        bytes memory _initializationParams
    ) public virtual override(CookieJarCore) initializer {
        (address _target, , , , address[] memory _allowList) = abi.decode(
            _initializationParams,
            (address, uint256, uint256, address, address[])
        );
        target = _target;

        CookieJarCore.setUp(_initializationParams);

        for (uint256 i = 0; i < _allowList.length; i++) {
            allowList[_allowList[i]] = true;
        }
    }

    function giveCookie(
        address cookieMonster,
        uint256 amount
    ) internal override(CookieJarCore) {
        return Giver6551.giveCookie(cookieMonster, amount, cookieToken);
    }

    function isAllowList() internal view override returns (bool) {
        return allowList[msg.sender];
    }

    function setAllowList(
        address _address,
        bool _isAllowed
    ) external onlyOwner {
        allowList[_address] = _isAllowed;
    }

    function batchAllowList(
        address[] memory _addresses,
        bool[] memory _isAlloweds
    ) external onlyOwner {
        require(
            _addresses.length == _isAlloweds.length,
            "CookieJar6551: length mismatch"
        );
        for (uint256 i = 0; i < _addresses.length; i++) {
            allowList[_addresses[i]] = _isAlloweds[i];
        }
    }
}
