// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface IHats {
    function isWearerOfHat(address _user, uint256 _hatId) external view returns (bool isWearer);

    function isAdminOfHat(address _user, uint256 _hatId) external view returns (bool isAdmin);

    function isInGoodStanding(address _wearer, uint256 _hatId) external view returns (bool standing);
}

contract MockHats is IHats {
    bool public response;
    function setMockResponse(bool _response) external {
        response = _response;
    }

    function isWearerOfHat(address /*_user*/, uint256 /*_hatId*/) external view override returns (bool isWearer) {
        return response;
    }

    function isAdminOfHat(address /*_user*/, uint256 /*_hatId*/) external view override returns (bool isAdmin) {
        return response;
    }

    function isInGoodStanding(address /*_user*/, uint256 /*_hatId*/) external view override returns (bool standing) {
        return response;
    }
}