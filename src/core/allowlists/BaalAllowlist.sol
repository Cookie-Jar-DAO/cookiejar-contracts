// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {IBaalToken} from "@daohaus/baal-contracts/contracts/interfaces/IBaalToken.sol";
import {IBaal} from "@daohaus/baal-contracts/contracts/interfaces/IBaal.sol";

contract BaalAllowlist {
    address public dao;
    uint256 public threshold;
    bool public useShares;
    bool public useLoot;

    function setUp(bytes memory _initializationParams) public virtual {
        (,,,, address _dao, uint256 _threshold, bool _useShares, bool _useLoot) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address, uint256, bool, bool));

        dao = _dao;
        threshold = _threshold;
        useShares = _useShares;
        useLoot = _useLoot;
    }

    function _isAllowList(address user) internal view returns (bool) {
        if (useShares && useLoot) {
            return IBaalToken(IBaal(dao).sharesToken()).balanceOf(user) >= threshold
                || IBaalToken(IBaal(dao).lootToken()).balanceOf(user) >= threshold;
        }
        if (useLoot) {
            return IBaalToken(IBaal(dao).lootToken()).balanceOf(user) >= threshold;
        }
        return IBaalToken(IBaal(dao).sharesToken()).balanceOf(user) >= threshold;
    }
}
