// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ARRAY_LENGTH_MISMATCH } from "src/lib/Errors.sol";

import { AllowlistBase } from "./AllowlistBase.sol";

/**
 * @title MappedAllowlist
 * @dev This contract provides a mechanism for maintaining an allowlist of addresses using a mapping.
 */
contract MappedAllowlist is AllowlistBase {
    /// @notice The mapping of addresses to their allowlist status.
    mapping(address => bool) public allowList;

    /**
     * @notice Sets up the allowlist with the provided initialization parameters.
     * @dev This function decodes the initialization parameters and sets the allowlist accordingly.
     * @param _initializationParams The parameters to initialize the allowlist. It should be encoded as (address,
     * uint256, uint256, address, address[]).
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override {
        (,,,, address[] memory _allowList) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address[]));

        for (uint256 i = 0; i < _allowList.length; i++) {
            allowList[_allowList[i]] = true;
        }
    }

    /**
     * @notice Checks if an address is in the allowlist.
     * @dev This function checks the allowlist status of the user in the mapping.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        return allowList[user];
    }

    /**
     * @notice Sets the allowlist status of an address.
     * @dev This function sets the allowlist status of the specified address in the mapping.
     * @param _address The address to set the allowlist status for.
     * @param _isAllowed The allowlist status to set.
     */
    function _setAllowList(address _address, bool _isAllowed) internal {
        allowList[_address] = _isAllowed;
    }

    /**
     * @notice Sets the allowlist status of multiple addresses.
     * @dev This function sets the allowlist status of the specified addresses in the mapping. The lengths of the
     * addresses and statuses arrays must match.
     * @param _addresses The addresses to set the allowlist status for.
     * @param _isAlloweds The allowlist statuses to set.
     */
    function _batchAllowList(address[] memory _addresses, bool[] memory _isAlloweds) internal {
        if (_addresses.length != _isAlloweds.length) {
            revert ARRAY_LENGTH_MISMATCH(_addresses.length, _isAlloweds.length);
        }
        for (uint256 i = 0; i < _addresses.length; i++) {
            allowList[_addresses[i]] = _isAlloweds[i];
        }
    }
}
