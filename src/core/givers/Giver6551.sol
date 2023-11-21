// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "forge-std/console2.sol";

abstract contract Giver6551 {
    address public target;
    address public collectionAddress;
    /// @notice The constant that represents percentage points for calculations.
    uint256 public constant PERC_POINTS = 1e6;

    /// @notice The fee charged on each transaction, set at 1% (10,000 out of a million).
    uint256 public constant SUSTAINABILITY_FEE = 10_000;

    /// @notice The address for the sustainability fee.
    address public constant SUSTAINABILITY_ADDR = 0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc;

    event EmptyJar(address indexed jar, address indexed token, uint256 amount);

    function emptyJar(address cookieToken) internal {
        AccountERC6551 targetContract = AccountERC6551(payable(target));

        uint256 balance;
        if (cookieToken == address(0)) {
            console2.log("emptying jar");
            balance = address(targetContract).balance;
            targetContract.executeTrustedCall(msg.sender, balance, bytes(""));
        } else {
            balance = ERC20(cookieToken).balanceOf(address(this));

            targetContract.executeTrustedCall(
                cookieToken,
                balance,
                abi.encodeWithSignature("transfer(address,uint256)", abi.encodePacked(msg.sender, balance))
            );
        }

        emit EmptyJar(target, cookieToken, balance);
    }

    function giveCookie(address cookieMonster, uint256 amount, address cookieToken) internal {
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
    }
}
