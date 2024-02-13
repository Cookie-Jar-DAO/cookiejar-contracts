// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { Giver6551 } from "src/core/givers/Giver6551.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";

contract CookieJar6551 is CookieJarCore, Giver6551 {
    function setUp(bytes memory _initializationParams) public virtual override(CookieJarCore) initializer {
        (address _target) = abi.decode(_initializationParams, (address));
        target = _target;

        super.setUp(_initializationParams);

        transferOwnership(_target);
    }

    function giveCookie(
        address cookieMonster,
        uint256 amount
    )
        internal
        override(CookieJarCore)
        returns (bytes32 cookieUid)
    {
        cookieUid = Giver6551.giveCookie(cookieMonster, amount, cookieToken);
    }
}
