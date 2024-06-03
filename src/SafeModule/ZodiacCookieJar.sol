// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { GiverZodiac } from "src/core/givers/GiverZodiac.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";

/**
 * @title ZodiacCookieJar
 * @dev This abstract contract extends GiverZodiac to provide a base for contracts that manage a cookie jar.
 */
abstract contract ZodiacCookieJar is GiverZodiac {
    /**
     * @notice Sets up the ZodiacCookieJar contract.
     * @dev This function is public and virtual, and it overrides the base contract's setup function.
     * It first calls the base contract's setUp function with the provided initialization parameters, then transfers the
     * ownership to the target.
     * @param _initializationParams The initialization parameters as bytes.
     */
    function setUp(bytes memory _initializationParams) public virtual override {
        super.setUp(_initializationParams);

        transferOwnership(target);
    }
}
