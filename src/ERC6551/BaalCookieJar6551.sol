// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { BaalAllowlist } from "src/core/allowlists/BaalAllowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract BaalCookieJar6551 is BaalAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }
}
