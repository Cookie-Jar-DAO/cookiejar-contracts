// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { Giver6551 } from "src/core/givers/Giver6551.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";

/**
 * @title CookieJar6551
 * @dev This contract extends Giver6551 and CookieJarCore to provide functionality specific to ERC6551.
 */
abstract contract CookieJar6551 is Giver6551 {
    /**
     * @notice Sets up the contract with the provided initialization parameters.
     * @dev This function decodes the initialization parameters, sets the target state variable, calls the parent setUp
     * function, and transfers ownership to the target.
     * @param _initializationParams The parameters to initialize the contract. It should be encoded as an address.
     */
    function setUp(bytes memory _initializationParams) public virtual override {
        super.setUp(_initializationParams);

        transferOwnership(target);
    }
}
