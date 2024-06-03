// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ERC20Allowlist } from "src/core/allowlists/ERC20Allowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract ERC20CookieJar6551 is ERC20Allowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }
}
