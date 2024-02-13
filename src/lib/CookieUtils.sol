// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

library CookieUtils {
    function getCookieUid() internal view returns (bytes32 cookieUid) {
        cookieUid = keccak256(abi.encodePacked(msg.sender, block.timestamp));
    }
}
