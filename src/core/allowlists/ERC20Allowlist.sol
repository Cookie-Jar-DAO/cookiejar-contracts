// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { AllowlistBase } from "./AllowlistBase.sol";

/**
 * @title ERC20Allowlist
 * @dev This contract provides a mechanism for maintaining an allowlist of addresses based on their ERC20 token balance.
 */
contract ERC20Allowlist is AllowlistBase {
    /// @notice The address of the ERC20 token.
    address public erc20Addr;

    /// @notice The minimum balance of ERC20 tokens required to be in the allowlist.
    uint256 public threshold;

    /**
     * @notice Sets up the allowlist with the ERC20 token address and threshold value.
     * @dev This function decodes the initialization parameters and sets the state variables accordingly.
     * @param _initializationParams The parameters to initialize the allowlist. It should be encoded as (address,
     * uint256, uint256, address, address, uint256).
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override {
        (,,,, address _erc20addr, uint256 _threshold) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address, uint256));

        erc20Addr = _erc20addr;
        threshold = _threshold;
    }

    /**
     * @notice Checks if an address has the required balance
     * @dev This function checks the balance of ERC20 tokens of the user. If the balance is greater than or equal to the
     * threshold, the user is in the allowlist.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        return IERC20(erc20Addr).balanceOf(user) >= threshold;
    }
}
