// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {HatsAllowlist} from "src/core/allowlists/HatsAllowlist.sol";
import {ZodiacCookieJar} from "src/SafeModule/ZodiacCookieJar.sol";

contract ZodiacHatsCookieJar is HatsAllowlist, ZodiacCookieJar {
    function setUp(bytes memory _initializationParams) public override(HatsAllowlist, ZodiacCookieJar) {
        HatsAllowlist.setUp(_initializationParams);

        ZodiacCookieJar.setUp(_initializationParams);
    }

    function isAllowList(address user) public view override returns (bool) {
        return HatsAllowlist._isAllowList(user);
    }
}
