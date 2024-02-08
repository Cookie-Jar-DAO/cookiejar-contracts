// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";

contract CookieJarUtilsTest is PRBTest, StdCheats {
    function testIdGeneration() external {
        bytes32 cookieUid = CookieUtils.getCookieUid();

        assertEq(cookieUid, keccak256(abi.encodePacked(msg.sender, block.timestamp)));
    }
}
