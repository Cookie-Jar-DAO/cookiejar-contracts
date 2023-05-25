// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {CookieJar6551} from "./CookieJar6551.sol";

contract OpenCookieJar6551 is CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override initializer {
        super.setUp(_initializationParams);
    }
}
