// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {CookieJar6551} from "./CookieJar6551.sol";
import {ERC721Allowlist} from "src/core/allowlists/ERC721Allowlist.sol";

contract ERC721CookieJar6551 is ERC721Allowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override(ERC721Allowlist, CookieJar6551) initializer {
        CookieJar6551.setUp(_initializationParams);
        ERC721Allowlist.setUp(_initializationParams);
    }

    function isAllowList(address user) internal view override returns (bool) {
        return ERC721Allowlist._isAllowList(user);
    }
}
