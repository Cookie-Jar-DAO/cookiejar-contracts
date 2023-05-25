// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {ZodiacCookieJar} from "src/SafeModule/ZodiacCookieJar.sol";
import {ERC721Allowlist} from "src/core/allowlists/ERC721Allowlist.sol";

contract ZodiacERC721CookieJar is ERC721Allowlist, ZodiacCookieJar {
    function setUp(bytes memory _initializationParams) public override initializer {
        ZodiacCookieJar.setUp(_initializationParams);
        ERC721Allowlist.setUpAllowlist(_initializationParams);
    }

    function isAllowList(address user) internal view override returns (bool) {
        return ERC721Allowlist._isAllowList(user);
    }
}
