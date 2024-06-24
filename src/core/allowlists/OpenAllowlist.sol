// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AllowlistBase } from "./AllowlistBase.sol";

/**
 * @title OpenAllowlist
 * @dev This contract extends AllowlistBase to provide a mechanism for maintaining an allowlist of addresses.
 */
contract OpenAllowlist is AllowlistBase {
    /**
     * @notice Initializes the Allowlist contract.
     * @dev This function is public and virtual, and it overrides the base contract's initialization function.
     * It calls the base contract's setUp function with the provided initialization parameters.
     * @param _initializationParams The initialization parameters as bytes.
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override { }

    /**
     * @notice Checks if an address is in the allowlist.
     * @dev This function is an internal view function that always returns true, indicating that all addresses are in
     * the allowlist by default.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist. Always returns true.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        return true;
    }
}
