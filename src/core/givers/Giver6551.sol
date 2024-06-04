// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { FactoryFriendly } from "@gnosis.pm/zodiac/contracts/factory/FactoryFriendly.sol";
import { GiverBase } from "./GiverBase.sol";
import { CookieJarCore } from "src/core/CookieJarCore.sol";

/**
 * @title Giver6551
 * @dev This contract extends GiverBase and provides a mechanism for giving cookies from a smart account.
 */
abstract contract Giver6551 is CookieJarCore {
    /// @notice The target address for the contract.
    address public target;

    function setUp(bytes memory _initializationParams) public virtual override {
        __Giver_init(_initializationParams);
        CookieJarCore.setUp(_initializationParams);
    }

    /**
     * @notice Sets up the contract with the provided initialization parameters.
     * @dev This function decodes the initialization parameters and sets the target state variable.
     * @param _initializationParams The parameters to initialize the contract. It should be encoded as an address.
     */
    function __Giver_init(bytes memory _initializationParams) public virtual override {
        (address _target) = abi.decode(_initializationParams, (address));
        target = _target;
    }

    /**
     * @notice Gives a cookie to a specified address.
     * @dev This function calculates the sustainability fee, executes a trusted call to transfer the fee and the
     * remaining amount to the specified address.
     * If the cookie token is the zero address, it transfers native currency. Otherwise, it transfers the specified
     * ERC20 token.
     * @param cookieMonster The address to receive the cookie.
     * @param amount The amount of cookie to be given.
     * @param cookieToken The address of the ERC20 token to be transferred. If it is the zero address, native currency
     * is transferred.
     * @return cookieUid A unique identifier for the cookie.
     */
    function _giveCookie(
        address cookieMonster,
        uint256 amount,
        address cookieToken
    )
        internal
        override
        returns (bytes32 cookieUid)
    {
        uint256 fee = (amount / PERC_POINTS) * SUSTAINABILITY_FEE;

        AccountERC6551 targetContract = AccountERC6551(payable(target));

        if (cookieToken == address(0)) {
            targetContract.executeTrustedCall(SUSTAINABILITY_ADDR, fee, bytes(""));
            targetContract.executeTrustedCall(cookieMonster, amount - fee, bytes(""));
        } else {
            targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(SUSTAINABILITY_ADDR, fee))
            );
            targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(cookieMonster, amount - fee))
            );
        }

        cookieUid = CookieUtils.getCookieUid();
    }
}
