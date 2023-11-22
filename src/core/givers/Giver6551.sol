// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";

abstract contract Giver6551 {
    address public target;
    /// @notice The constant that represents percentage points for calculations.
    uint256 public constant PERC_POINTS = 1e6;

    /// @notice The fee charged on each transaction, set at 1% (10,000 out of a million).
    uint256 public constant SUSTAINABILITY_FEE = 10_000;

    /// @notice The address for the sustainability fee.
    address public constant SUSTAINABILITY_ADDR = 0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc;

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

     function eatCookies(
        uint256 amount,
         address cookieToken
     ) internal {

        AccountERC6551 targetContract = AccountERC6551(payable(target));
        
        address cookieMonster = msg.sender;

        if (cookieToken == address(0)) {

            // make transfer
             targetContract.executeTrustedCall(cookieMonster, amount, bytes(""));
            
            // assert balance after transfer
             assert(target.balance == 0);

        } else {

            // make transfer
            targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature("transfer(address,uint256)", cookieMonster, amount)
            );

            // get balance
            uint256 balance =  abi.decode(targetContract.executeTrustedCall(
                cookieToken,
                0,
                abi.encodeWithSignature("balanceOf(address)", target)
            ), (uint256));

            // assert valid transfer
            assert(balance == 0);
        }
          
    }
}
