// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract ERC721Allowlist {
    address public erc721Addr;

    function setUp(bytes memory _initializationParams) public virtual {
        (,,,, address _erc721addr) = abi.decode(_initializationParams, (address, uint256, uint256, address, address));

        erc721Addr = _erc721addr;
    }

    function _isAllowList(address user) internal view returns (bool) {
        return IERC721(erc721Addr).balanceOf(user) > 0;
    }
}
