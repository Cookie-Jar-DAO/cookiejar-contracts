// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {BaalAllowlist} from "src/core/allowlists/BaalAllowlist.sol";
import {ZodiacCookieJar} from "./ZodiacCookieJar.sol";

contract ZodiacBaalCookieJar is BaalAllowlist, ZodiacCookieJar {
    function setUp(bytes memory _initializationParams) public override initializer {
        ZodiacCookieJar.setUp(_initializationParams);
        BaalAllowlist.setUpAllowlist(_initializationParams);
    }

    function isAllowList(address user) internal view override returns (bool) {
        return BaalAllowlist._isAllowList(user);
    }
}
