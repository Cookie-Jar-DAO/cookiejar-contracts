// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { HatsAllowlist } from "src/core/allowlists/HatsAllowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract HatsCookieJar6551 is HatsAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override(HatsAllowlist, CookieJar6551) {
        HatsAllowlist.setUp(_initializationParams);
        CookieJar6551.setUp(_initializationParams);
    }

    function isAllowList(address user) public view override returns (bool) {
        return HatsAllowlist._isAllowList(user);
    }
}
