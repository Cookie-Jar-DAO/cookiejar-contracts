// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { MappedAllowlist } from "src/core/allowlists/MappedAllowlist.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract ListCookieJar6551 is MappedAllowlist, CookieJar6551 {
    function setUp(bytes memory _initializationParams) public override {
        __Allowlist_init(_initializationParams);
        super.setUp(_initializationParams);
    }

    function setAllowList(address _address, bool _isAllowed) external onlyOwner {
        _setAllowList(_address, _isAllowed);
    }

    function batchAllowList(address[] memory _addresses, bool[] memory _isAllowed) external onlyOwner {
        _batchAllowList(_addresses, _isAllowed);
    }
}
