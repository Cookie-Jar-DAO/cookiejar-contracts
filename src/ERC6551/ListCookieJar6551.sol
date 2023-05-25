// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {CookieJar6551} from "./CookieJar6551.sol";
import {MappedAllowlist} from "src/core/allowlists/MappedAllowlist.sol";

contract ListCookieJar6551 is MappedAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override initializer {
        CookieJar6551.setUp(_initializationParams);
        MappedAllowlist.setUpAllowlist(_initializationParams);
    }

    function isAllowList(address user) internal view override returns (bool) {
        return MappedAllowlist._isAllowList(user);
    }

    function setAllowList(address _address, bool _isAllowed) external onlyOwner {
        allowList[_address] = _isAllowed;
    }

    function batchAllowList(address[] memory _addresses, bool[] memory _isAllowed) external onlyOwner {
        MappedAllowlist._batchAllowList(_addresses, _isAllowed);
    }
}
