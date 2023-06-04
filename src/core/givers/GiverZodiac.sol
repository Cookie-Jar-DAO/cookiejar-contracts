// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {Module} from "@gnosis.pm/zodiac/contracts/core/Module.sol";
import {Enum} from "@gnosis.pm/safe-contracts/contracts/common/Enum.sol";

abstract contract GiverZodiac is Module {
    /// @notice The constant that represents percentage points for calculations.
    uint256 public constant PERC_POINTS = 1e6;

    /// @notice The fee charged on each transaction, set at 1% (10,000 out of a million).
    uint256 public constant SUSTAINABILITY_FEE = 10_000;

    /// @notice The address for the sustainability fee.
    address public constant SUSTAINABILITY_ADDR = 0x4A9a27d614a74Ee5524909cA27bdBcBB7eD3b315;

    function giveCookie(address cookieMonster, uint256 amount, address cookieToken) internal {
        uint256 fee = (amount / PERC_POINTS) * SUSTAINABILITY_FEE;

        // module exec

        if (cookieToken == address(0)) {
            require(exec(SUSTAINABILITY_ADDR, fee, bytes(""), Enum.Operation.Call), "call failure setup");
            require(exec(cookieMonster, amount - fee, bytes(""), Enum.Operation.Call), "call failure setup");
        } else {
            require(
                exec(
                    cookieToken,
                    0,
                    abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(SUSTAINABILITY_ADDR, fee)),
                    Enum.Operation.Call
                ),
                "call failure setup"
            );

            require(
                exec(
                    cookieToken,
                    0,
                    abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(cookieMonster, amount - fee)),
                    Enum.Operation.Call
                ),
                "call failure setup"
            );
        }
    }

}
