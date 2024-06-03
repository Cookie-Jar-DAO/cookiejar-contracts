// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ZodiacCookieJar } from "src/SafeModule/ZodiacCookieJar.sol";
import { OpenAllowlist } from "../core/allowlists/OpenAllowlist.sol";

/**
 * @title ZodiacOpenCookieJar
 * @dev This contract extends OpenAllowlist and ZodiacCookieJar to provide a mechanism for maintaining a cookie jar with
 * an open allowlist.
 */
contract ZodiacOpenCookieJar is OpenAllowlist, ZodiacCookieJar {
    /**
     * @notice Sets up the ZodiacOpenCookieJar contract.
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
