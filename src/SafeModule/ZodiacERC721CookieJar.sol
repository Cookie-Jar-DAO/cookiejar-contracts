// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ZodiacCookieJar } from "src/SafeModule/ZodiacCookieJar.sol";
import { ERC721Allowlist } from "src/core/allowlists/ERC721Allowlist.sol";

/**
 * @title ZodiacERC721CookieJar
 * @dev This contract extends ERC721Allowlist and ZodiacCookieJar to provide a mechanism for maintaining a cookie jar
 * with an ERC721 allowlist.
 */
contract ZodiacERC721CookieJar is ERC721Allowlist, ZodiacCookieJar {
    /**
     * @notice Sets up the ZodiacERC721CookieJar contract.
     * @dev This function is public and overrides the base contracts' setup functions.
     * It first calls the __Allowlist_init function with the provided initialization parameters, then calls the base
     * contracts' setup functions.
     * @param _initializationParams The initialization parameters as bytes.
     */
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }
}
