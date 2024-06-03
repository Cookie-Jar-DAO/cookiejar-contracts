// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { BaalAllowlist } from "src/core/allowlists/BaalAllowlist.sol";
import { ZodiacCookieJar } from "./ZodiacCookieJar.sol";

/**
 * @title ZodiacBaalCookieJar
 * @dev This contract extends BaalAllowlist and ZodiacCookieJar to provide a mechanism for maintaining a cookie jar with
 * an allowlist.
 */
contract ZodiacBaalCookieJar is BaalAllowlist, ZodiacCookieJar {
    /**
     * @notice Sets up the ZodiacBaalCookieJar contract.
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
