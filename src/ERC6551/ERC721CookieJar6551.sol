// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ERC721Allowlist } from "src/core/allowlists/ERC721Allowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract ERC721CookieJar6551 is ERC721Allowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override(ERC721Allowlist, CookieJar6551) {
        ERC721Allowlist.setUp(_initializationParams);

        CookieJar6551.setUp(_initializationParams);
    }

    function isAllowList(address user) public view override returns (bool) {
        return ERC721Allowlist._isAllowList(user);
    }
}
