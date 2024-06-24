// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { MappedAllowlist } from "src/core/allowlists/MappedAllowlist.sol";
import { ZodiacCookieJar } from "src/SafeModule/ZodiacCookieJar.sol";

/**
 * @title ZodiacListCookieJar
 * @dev This contract extends MappedAllowlist and ZodiacCookieJar to provide a mechanism for maintaining a cookie jar
 * with a mapped allowlist.
 */
contract ZodiacListCookieJar is MappedAllowlist, ZodiacCookieJar {
    /**
     * @notice Sets up the ZodiacListCookieJar contract.
     * @dev This function is public and overrides the base contracts' setup functions.
     * It first calls the __Allowlist_init function with the provided initialization parameters, then calls the base
     * contracts' setup functions.
     * @param _initializationParams The initialization parameters as bytes.
     */
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }

    /**
     * @notice Sets the allowlist status of an address.
     * @dev This function is external and can only be called by the owner.
     * It calls the _setAllowList function with the provided address and allowlist status.
     * @param _address The address to set the allowlist status for.
     * @param _isAllowed The allowlist status to set for the address.
     */
    function setAllowList(address _address, bool _isAllowed) external onlyOwner {
        _setAllowList(_address, _isAllowed);
    }

    /**
     * @notice Sets the allowlist status of a batch of addresses.
     * @dev This function is external and can only be called by the owner.
     * It calls the _batchAllowList function with the provided addresses and allowlist statuses.
     * @param _addresses The addresses to set the allowlist status for.
     * @param _isAllowed The allowlist statuses to set for the addresses.
     */
    function batchAllowList(address[] memory _addresses, bool[] memory _isAllowed) external onlyOwner {
        _batchAllowList(_addresses, _isAllowed);
    }
}
