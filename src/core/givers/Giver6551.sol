// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {AccountERC6551} from "src/ERC6551/erc6551/ERC6551Module.sol";

abstract contract Giver6551 {
    address public target;
    /// @notice The constant that represents percentage points for calculations.
    uint256 public constant PERC_POINTS = 1e6;

    /// @notice The fee charged on each transaction, set at 1% (10,000 out of a million).
    uint256 public constant SUSTAINABILITY_FEE = 10_000;

    /// @notice The address for the sustainability fee.
    address public constant SUSTAINABILITY_ADDR =
        0x4A9a27d614a74Ee5524909cA27bdBcBB7eD3b315;

    function giveCookie(
        address cookieMonster,
        uint256 amount,
        address cookieToken
    ) internal {
        uint256 fee = (amount / PERC_POINTS) * SUSTAINABILITY_FEE;

        AccountERC6551 targetContract = AccountERC6551(payable(target));

        if (cookieToken == address(0)) {
            targetContract.executeTrustedCall(
                SUSTAINABILITY_ADDR,
                fee,
                bytes("")
            );
            targetContract.executeTrustedCall(
                cookieMonster,
                amount - fee,
                bytes("")
            );
        } else {
            targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    abi.encodePacked(SUSTAINABILITY_ADDR, fee)
                )
            );
            targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature(
                    "transfer(address,uint256)",
                    abi.encodePacked(cookieMonster, amount - fee)
                )
            );
        }
    }
}
