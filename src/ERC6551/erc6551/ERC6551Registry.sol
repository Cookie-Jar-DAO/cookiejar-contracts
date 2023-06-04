// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Create2} from "@openzeppelin/contracts/utils/Create2.sol";

import "src/lib/ERC6551BytecodeLib.sol";

import "src/interfaces/IERC6551Registry.sol";
import "src/interfaces/IERC6551.sol";
import "src/ERC6551/erc6551/ERC6551Registry.sol";

/**
 * @title A registry for token bound accounts
 * @dev Determines the address for each token bound account and performs deployment of accounts
 * @author https://github.com/ethereum/EIPs/pull/6551/files
 */

contract AccountRegistry is IRegistry {
    error InitializationFailed();

    function createAccount(
        address implementation,
        uint256 chainId,
        address tokenContract,
        uint256 tokenId,
        uint256 salt,
        bytes calldata initData
    ) external returns (address) {
        bytes memory code = ERC6551BytecodeLib.getCreationCode(implementation, chainId, tokenContract, tokenId, salt);

        address _account = Create2.computeAddress(bytes32(salt), keccak256(code));

        if (_account.code.length != 0) return _account;

        emit AccountCreated(_account, implementation, chainId, tokenContract, tokenId, salt);

        _account = Create2.deploy(0, bytes32(salt), code);

        if (initData.length != 0) {
            (bool success,) = _account.call(initData);
            if (!success) revert InitializationFailed();
        }

        return _account;
    }

    function account(address implementation, uint256 chainId, address tokenContract, uint256 tokenId, uint256 salt)
        external
        view
        returns (address)
    {
        bytes32 bytecodeHash =
            keccak256(ERC6551BytecodeLib.getCreationCode(implementation, chainId, tokenContract, tokenId, salt));

        return Create2.computeAddress(bytes32(salt), bytecodeHash);
    }
}
