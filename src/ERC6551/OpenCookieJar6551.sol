// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract OpenCookieJar6551 is CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        CookieJar6551.setUp(_initializationParams);
    }
}
