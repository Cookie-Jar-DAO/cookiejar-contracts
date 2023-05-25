// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ERC20Allowlist {
    address public erc20Addr;
    uint256 public threshold;

    function setUpAllowlist(bytes memory _initializationParams) public {
        (,,,, address _erc20addr, uint256 _threshold) =
            abi.decode(_initializationParams, (address, uint256, uint256, address, address, uint256));

        erc20Addr = _erc20addr;
        threshold = _threshold;
    }

    function _isAllowList(address user) internal view returns (bool) {
        return IERC20(erc20Addr).balanceOf(user) >= threshold;
    }
}
