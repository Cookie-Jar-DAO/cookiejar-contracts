// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import "forge-std/console2.sol";

contract CookieUtilsHarnass {
    function getCookieJarUid(address cookieJarAddr) public view returns (string memory) {
        return CookieUtils.getCookieJarUid(cookieJarAddr);
    }

    function getCookieUid(string memory cookieJarUid) public view returns (string memory) {
        return CookieUtils.getCookieUid(cookieJarUid);
    }
}

contract CookieJarUtilsTest is PRBTest, StdCheats {
    CookieUtilsHarnass internal utils;

    function setUp() public virtual {
        utils = new CookieUtilsHarnass();
    }

    function testIdGeneration() external {
        string memory cookieJarUid = utils.getCookieJarUid(address(this));
        string memory cookieUid = utils.getCookieUid(cookieJarUid);

        console2.log(cookieJarUid);
        console2.log(cookieUid);

        assertEq(
            cookieJarUid,
            string(abi.encodePacked(Strings.toHexString(uint160(address(this))), Strings.toHexString(block.chainid)))
        );
    }
}
