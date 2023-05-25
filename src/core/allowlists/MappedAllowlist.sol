// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

contract MappedAllowlist {
    mapping(address allowed => bool exists) public allowList;

    function setUpAllowlist(bytes memory _initializationParams) public {
        (,,,, address[] memory _allowList) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address[]));

        for (uint256 i = 0; i < _allowList.length; i++) {
            allowList[_allowList[i]] = true;
        }
    }

    function _isAllowList(address user) internal view returns (bool) {
        return allowList[user];
    }

    function _setAllowList(address _address, bool _isAllowed) internal {
        allowList[_address] = _isAllowed;
    }

    function _batchAllowList(address[] memory _addresses, bool[] memory _isAlloweds) internal {
        require(_addresses.length == _isAlloweds.length, "CookieJar6551: length mismatch");
        for (uint256 i = 0; i < _addresses.length; i++) {
            allowList[_addresses[i]] = _isAlloweds[i];
        }
    }
}
