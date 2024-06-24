// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { Module } from "@gnosis.pm/zodiac/contracts/core/Module.sol";
import { FactoryFriendly } from "@gnosis.pm/zodiac/contracts/factory/FactoryFriendly.sol";

import { Enum } from "@gnosis.pm/safe-contracts/contracts/common/Enum.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { CookieJarCore } from "src/core/CookieJarCore.sol";

import { CALL_FAILED } from "src/lib/Errors.sol";
import { GiverBase } from "./GiverBase.sol";

/**
 * @title GiverZodiac
 * @dev This contract extends GiverBase and provides a mechanism for giving cookies using the Zodiac module.
 */
abstract contract GiverZodiac is Module, CookieJarCore {
    function setUp(bytes memory _initializationParams) public virtual override(FactoryFriendly, CookieJarCore) {
        __Giver_init(_initializationParams);
        CookieJarCore.setUp(_initializationParams);
    }

    function __Giver_init(bytes memory _initializationParams) public virtual override {
        (address _safeTarget) = abi.decode(_initializationParams, (address));

        avatar = _safeTarget;
        target = _safeTarget;
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

        // module exec

        if (cookieToken == address(0)) {
            if (!exec(SUSTAINABILITY_ADDR, fee, bytes(""), Enum.Operation.Call)) {
                revert CALL_FAILED("fund sustainability native");
            }
            if (!exec(cookieMonster, amount - fee, bytes(""), Enum.Operation.Call)) {
                revert CALL_FAILED("fund cookieMonster native");
            }
        } else {
            if (
                !exec(
                    cookieToken,
                    0,
                    abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(SUSTAINABILITY_ADDR, fee)),
                    Enum.Operation.Call
                )
            ) {
                revert CALL_FAILED("fund sustainability erc20");
            }

            if (
                !exec(
                    cookieToken,
                    0,
                    abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(cookieMonster, amount - fee)),
                    Enum.Operation.Call
                )
            ) {
                revert CALL_FAILED("fund cookieMonster erc20");
            }
        }

        cookieUid = CookieUtils.getCookieUid();
    }
}
