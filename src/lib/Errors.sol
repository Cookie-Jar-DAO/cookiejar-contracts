// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

/// @notice This error is thrown when the lengths of two arrays do not match.
/// @param a The length of the first array.
/// @param b The length of the second array.
error ARRAY_LENGTH_MISMATCH(uint256 a, uint256 b);

/// @notice This error is thrown when a call to a function or contract fails.
/// @param message The error message.
error CALL_FAILED(string message);

/// @notice This error is thrown when an invalid token ID is used.
/// @param tokenId The invalid token ID.
error INVALID_TOKEN_ID(uint256 tokenId);

/// @notice This error is thrown when an action is not allowed.
/// @param message The error message.
error NOT_ALLOWED(string message);

/// @notice This error is thrown when the caller is not the approved address or the owner of a token.
error NOT_APPROVED_OR_OWNER();
