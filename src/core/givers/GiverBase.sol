// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { CookieJarCore } from "../CookieJarCore.sol";
import { IGiver } from "../../interfaces/IGiver.sol";

/**
 * @title GiverBase
 * @dev This is an abstract contract that provides a mechanism for giving cookies.
 */
abstract contract GiverBase is IGiver {
    /// @notice The constant that represents percentage points for calculations.
    uint256 public constant PERC_POINTS = 1e6;

    /// @notice The fee charged on each transaction, set at 1% (10,000 out of a million).
    uint256 public constant SUSTAINABILITY_FEE = 10_000;

    /// @notice The address for the sustainability fee.
    address public constant SUSTAINABILITY_ADDR = 0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc;

    function __Giver_init(bytes memory _initializationParams) public virtual;

    /**
     * @notice Gives a cookie to a specified address.
     * @dev This function is internal and virtual, and returns a unique identifier for the cookie.
     * @param cookieMonster The address to which the cookie will be given.
     * @param amount The amount of cookies to give.
     * @param cookieToken The address of the cookie token contract.
     * @return cookieUid A unique identifier for the given cookie.
     */
    function _giveCookie(
        address cookieMonster,
        uint256 amount,
        address cookieToken
    )
        internal
        virtual
        returns (bytes32 cookieUid);
}
