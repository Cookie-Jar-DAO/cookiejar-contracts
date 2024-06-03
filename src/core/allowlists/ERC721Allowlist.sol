// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { AllowlistBase } from "./AllowlistBase.sol";

/**
 * @title ERC721Allowlist
 * @dev This contract provides a mechanism for maintaining an allowlist of addresses based on their ERC721 token
 * ownership.
 */
contract ERC721Allowlist is AllowlistBase {
    /// @notice The address of the ERC721 token.
    address public erc721Addr;

    /**
     * @notice Sets up the allowlist with the ERC721 contract address.
     * @dev This function decodes the initialization parameters and sets the state variables accordingly.
     * @param _initializationParams The parameters to initialize the allowlist. It should be encoded as (address,
     * uint256, uint256, address, address).
     */
    function __Allowlist_init(bytes memory _initializationParams) public virtual override {
        (,,,, address _erc721addr) = abi.decode(_initializationParams, (address, uint256, uint256, address, address));

        erc721Addr = _erc721addr;
    }

    /**
     * @notice Checks if an address is in the allowlist by asserting a balance larger than 0.
     * @dev This function checks the ownership of ERC721 tokens of the user. If the user owns at least one token, the
     * user is in the allowlist.
     * @param user The address to check.
     * @return A boolean indicating whether the address is in the allowlist.
     */
    function _isAllowList(address user) internal view override returns (bool) {
        return IERC721(erc721Addr).balanceOf(user) > 0;
    }
}
