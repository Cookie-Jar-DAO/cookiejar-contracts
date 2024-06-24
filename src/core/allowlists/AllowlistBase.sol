// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { IAllowlist } from "../../interfaces/IAllowlist.sol";

/**
 * @title AllowlistBase
 * @dev This contract provides the basic implementation for an allowlist. All claims are allowed by default.
 */
abstract contract AllowlistBase is IAllowlist {
    /**
     * @notice Sets up the allowlist.
     * @dev This function decodes the initialization parameters and sets the state variables accordingly.
     * @param _initializationParams The parameters to initialize the allowlist.
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual;

    /**
     * @notice Checks if the caller is a member.
     * @dev In this base contract, it always returns true, but is expected to be overridden in a derived contract with
     * specific logic to determine membership.
     * @param user The address of the user to check membership. This parameter is not used in this base contract.
     * @return A boolean indicating whether the caller is a member. Always returns true in this base contract.
     */
    function isAllowList(address user) public view virtual override returns (bool) {
        return _isAllowList(user);
    }

    /**
     * @notice Checks if an address is in the allowlist.
     * @dev This function is an internal view function that always returns true, indicating that all addresses are in
     * the allowlist by default.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist. Always returns true.
     */
    function _isAllowList(address user) internal view virtual returns (bool);
}
