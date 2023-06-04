// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

library CookieUtils {
   
    function getCookieJarUid(address cookieJarAddr) internal view returns (string memory) {
        return string(abi.encodePacked(Strings.toHexString(uint160(cookieJarAddr)), Strings.toHexString(block.chainid)));
    }

    function getCookieUid(string memory cookieJarUid) internal view returns (string memory) {
        return bytes32ToString(keccak256(abi.encodePacked(cookieJarUid, msg.sender, block.timestamp)));
    }

    /**
     * @notice Converts a bytes32 value to a string.
     * @dev This is a helper function that is used to convert bytes32 values to strings, for example, to convert hashed
     * values
     * to their string representation.
     * @param _b The bytes32 value to convert.
     * @return The string representation of the given bytes32 value.
     */

    function bytes32ToString(bytes32 _b) private pure returns (string memory) {
        return string(abi.encodePacked(_b));
    }
}
