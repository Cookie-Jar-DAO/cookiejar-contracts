// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { IBaalToken } from "@daohaus/baal-contracts/contracts/interfaces/IBaalToken.sol";
import { IBaal } from "@daohaus/baal-contracts/contracts/interfaces/IBaal.sol";
import { AllowlistBase } from "./AllowlistBase.sol";

/**
 * @title BaalAllowlist
 * @dev This contract implements the IAllowlist interface and provides a mechanism for maintaining an allowlist of
 * addresses based on the Baal DAO's shares and loot tokens.
 */
contract BaalAllowlist is AllowlistBase {
    /// @notice The address of the Baal DAO.
    address public dao;

    /// @notice The minimum balance of shares or loot tokens required to be in the allowlist.
    uint256 public threshold;

    /// @notice A boolean indicating whether shares are used for the allowlist.
    bool public useShares;

    /// @notice A boolean indicating whether loot tokens are used for the allowlist.
    bool public useLoot;

    /**
     * @notice Sets up the allowlist that allows access to the cookie jar based on DAO token balances.
     * @dev This function decodes the initialization parameters and sets the state variables accordingly.
     * @param _initializationParams The parameters to initialize the allowlist. It should be encoded as (address,
     * uint256, uint256, address, address, uint256, bool, bool).
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override {
        (,,,, address _dao, uint256 _threshold, bool _useShares, bool _useLoot) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address, uint256, bool, bool));

        dao = _dao;
        threshold = _threshold;
        useShares = _useShares;
        useLoot = _useLoot;
    }

    /**
     * @notice Checks if an address has the required token balances.
     * @dev This function checks the balance of shares and/or loot tokens of the user in the Baal DAO. If the balance is
     * greater than or equal to the threshold, the user is in the allowlist.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        if (useShares && useLoot) {
            return IBaalToken(IBaal(dao).sharesToken()).balanceOf(user) >= threshold
                || IBaalToken(IBaal(dao).lootToken()).balanceOf(user) >= threshold;
        }
        if (useLoot) {
            return IBaalToken(IBaal(dao).lootToken()).balanceOf(user) >= threshold;
        }
        return IBaalToken(IBaal(dao).sharesToken()).balanceOf(user) >= threshold;
    }
}
