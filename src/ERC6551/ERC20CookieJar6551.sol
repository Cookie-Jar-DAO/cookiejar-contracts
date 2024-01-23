// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ERC20Allowlist } from "src/core/allowlists/ERC20Allowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract ERC20CookieJar6551 is ERC20Allowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override(ERC20Allowlist, CookieJar6551) {
        ERC20Allowlist.setUp(_initializationParams);

        CookieJar6551.setUp(_initializationParams);
    }

    function isAllowList(address user) public view override returns (bool) {
        return ERC20Allowlist._isAllowList(user);
    }
}
