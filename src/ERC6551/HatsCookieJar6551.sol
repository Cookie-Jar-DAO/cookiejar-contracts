// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { HatsAllowlist } from "src/core/allowlists/HatsAllowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract HatsCookieJar6551 is HatsAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }
}
