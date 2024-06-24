// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

/**
 * @title IAllowlist
 * @dev This is an interface for an allowlist used by the cookie jar
 */
interface IAllowlist {
    /**
     * @notice Sets up the allowlist with the provided initialization parameters.
     * @dev This function first inits the allow list and then the core contract.
     * @param _initializationParams The parameters to initialize the allowlist.
     */
    function __Allowlist_init(bytes memory _initializationParams) external;

    /**
     * @notice Checks if an address is in the allowlist.
     * @dev Checks against specified allowlist mechanism
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function isAllowList(address user) external view returns (bool);
}
