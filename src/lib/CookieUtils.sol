// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

/**
 * @title CookieUtils
 * @dev This library provides utility functions for working with cookies.
 */
library CookieUtils {
    /**
     * @notice Generates a unique identifier for a cookie for reference purposes.
     * @dev This function is internal and view, and it returns a bytes32 value.
     * It generates the unique identifier by hashing the sender's address and the current block timestamp.
     * @return cookieUid The unique identifier for a cookie.
     */
    function getCookieUid() internal view returns (bytes32 cookieUid) {
        cookieUid = keccak256(abi.encodePacked(msg.sender, block.timestamp));
    }
}
