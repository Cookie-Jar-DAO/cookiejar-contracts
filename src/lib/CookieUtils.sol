// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

library CookieUtils {
    function getCookieJarUid(address cookieJarAddr) internal view returns (string memory) {
        return string(abi.encodePacked(Strings.toHexString(uint160(cookieJarAddr)), Strings.toHexString(block.chainid)));
    }

    function getCookieUid(string memory cookieJarUid) internal view returns (string memory) {
        return Strings.toHexString(
            uint256(
                keccak256(
                    abi.encodePacked(
                        cookieJarUid, Strings.toHexString(msg.sender), Strings.toHexString(block.timestamp)
                    )
                )
            )
        );
    }
}
