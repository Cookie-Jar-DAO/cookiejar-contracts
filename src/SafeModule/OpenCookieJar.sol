// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {ZodiacCookieJar} from "src/SafeModule/ZodiacCookieJar.sol";

contract ZodiacOpenCookieJar is ZodiacCookieJar {
    function setUp(bytes memory _initializationParams) public override initializer {
        ZodiacCookieJar.setUp(_initializationParams);
    }
}
