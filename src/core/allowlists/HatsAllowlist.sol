// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AllowlistBase } from "./AllowlistBase.sol";

// https://github.com/Hats-Protocol/hats-protocol/blob/b43ad0d1dbe4a4190febc036ee8a2849e3f221b4/src/Interfaces/IHats.sol
interface IHats {
    function isWearerOfHat(address _user, uint256 _hatId) external view returns (bool isWearer);
}

/**
 * @title HatsAllowlist
 * @dev This contract provides a mechanism for maintaining an allowlist of addresses based on their ownership of a
 * specific hat in the Hats Protocol.
 */
contract HatsAllowlist is AllowlistBase {
    /// @notice https://docs.hatsprotocol.xyz/using-hats/hats-protocol-supported-chains
    /// @notice The address of the Hats Protocol contract.
    address public constant HATS_ADDRESS = 0x3bc1A0Ad72417f2d411118085256fC53CBdDd137;

    /// @notice The ID of the hat used for the allowlist.
    uint256 public hatId;

    /**
     * @notice Sets up the allowlist with the HatID to check against.
     * @dev This function decodes the initialization parameters and sets the state variables accordingly.
     * @param _initializationParams The parameters to initialize the allowlist. It should be encoded as (address,
     * uint256, uint256, address, address, uint256).
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override {
        (,,,, uint256 _hatId) = abi.decode(_initializationParams, (address, uint256, uint256, address, uint256));

        hatId = _hatId;
    }

    /**
     * @notice Checks if an address is in the allowlist.
     * @dev This function checks if the user is a wearer of the specified hat in the Hats Protocol. If the user is a
     * wearer, the user is in the allowlist.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        return IHats(HATS_ADDRESS).isWearerOfHat(user, hatId);
    }
}
