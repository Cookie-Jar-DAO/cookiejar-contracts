// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {CookieJar6551} from "./CookieJar6551.sol";
import {BaalAllowlist} from "src/core/allowlists/BaalAllowlist.sol";

contract BaalCookieJar6551 is BaalAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override(BaalAllowlist, CookieJar6551) initializer {
        CookieJar6551.setUp(_initializationParams);
        BaalAllowlist.setUp(_initializationParams);
    }

    function isAllowList(address user) internal view override returns (bool) {
        return BaalAllowlist._isAllowList(user);
    }
}
