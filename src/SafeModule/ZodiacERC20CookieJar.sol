// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {ERC20Allowlist} from "src/core/allowlists/ERC20Allowlist.sol";
import {ZodiacCookieJar} from "src/SafeModule/ZodiacCookieJar.sol";

contract ZodiacERC20CookieJar is ERC20Allowlist, ZodiacCookieJar {
    function setUp(bytes memory _initializationParams) public override(ERC20Allowlist, ZodiacCookieJar) {
        ERC20Allowlist.setUp(_initializationParams);

        ZodiacCookieJar.setUp(_initializationParams);
    }

    function isAllowList(address user) public view override returns (bool) {
        return ERC20Allowlist._isAllowList(user);
    }
}
