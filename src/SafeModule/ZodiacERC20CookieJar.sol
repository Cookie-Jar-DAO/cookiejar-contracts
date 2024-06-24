// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ERC20Allowlist } from "src/core/allowlists/ERC20Allowlist.sol";
import { ZodiacCookieJar } from "src/SafeModule/ZodiacCookieJar.sol";

/**
 * @title ZodiacERC20CookieJar
 * @dev This contract extends ERC20Allowlist and ZodiacCookieJar to provide a mechanism for maintaining a cookie jar
 * with an ERC20 allowlist.
 */
contract ZodiacERC20CookieJar is ERC20Allowlist, ZodiacCookieJar {
    /**
     * @notice Sets up the ZodiacERC20CookieJar contract.
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
