// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";
import { OpenAllowlist } from "../core/allowlists/OpenAllowlist.sol";

contract OpenCookieJar6551 is OpenAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }
}
