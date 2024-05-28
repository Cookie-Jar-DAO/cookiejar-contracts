// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

// https://github.com/Hats-Protocol/hats-protocol/blob/b43ad0d1dbe4a4190febc036ee8a2849e3f221b4/src/Interfaces/IHats.sol
interface IHats {
    function isWearerOfHat(address _user, uint256 _hatId) external view returns (bool isWearer);

    function isAdminOfHat(address _user, uint256 _hatId) external view returns (bool isAdmin);

    function isInGoodStanding(address _wearer, uint256 _hatId) external view returns (bool standing);
}

contract HatsAllowlist {
    // https://docs.hatsprotocol.xyz/using-hats/hats-protocol-supported-chains
    address public hatsAddr;
    uint256 public hatsId;

    function setUp(bytes memory _initializationParams) public virtual {
        (,,,, address _hatsAddr, uint256 _hatsId) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address, uint256));

        hatsId = _hatsId;
        hatsAddr = _hatsAddr;
    }

    function _isAllowList(address user) internal view returns (bool) {
        return IHats(hatsAddr).isWearerOfHat(user, hatsId) && IHats(hatsAddr).isInGoodStanding(user, hatsId);
    }
}
