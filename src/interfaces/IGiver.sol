// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

/**
 * @title IGiver
 * @dev This is an interface for a giver  used by the cookie jar
 */
interface IGiver {
    /**
     * @notice Sets up the allowlist with the provided initialization parameters.
     * @dev This function first inits the allow list and then the core contract.
     * @param _initializationParams The parameters to initialize the allowlist.
     */
    function __Giver_init(bytes memory _initializationParams) external;
}
