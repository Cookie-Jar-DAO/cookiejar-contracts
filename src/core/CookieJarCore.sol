// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ICookieJar } from "src/interfaces/ICookieJar.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { GiverBase } from "src/core/givers/GiverBase.sol";

import { NOT_ALLOWED, CALL_FAILED } from "src/lib/Errors.sol";
import { IAllowlist } from "../interfaces/IAllowlist.sol";
import { FactoryFriendly } from "zodiac/factory/FactoryFriendly.sol";
import { AllowlistBase } from "./allowlists/AllowlistBase.sol";

/**
 * @title CookieJarCore
 * @notice A base contract for a cookie jar that distributes tokens to members of a DAO.
 * @dev This contract is intended to be inherited by a derived contract that implements the logic for distributing
 * tokens to members of a DAO. The derived contract should implement the giveCookie function to handle the logic of
 * transferring the specified amount of cookies to the given address and return a unique identifier for the cookie.
 */
abstract contract CookieJarCore is GiverBase, AllowlistBase, ICookieJar, Initializable, OwnableUpgradeable {
    /// @notice The amount of "cookie" that can be claimed.
    uint256 public cookieAmount;

    /// @notice The address of the token that is being distributed.
    address public cookieToken;

    /// @notice The length of the period between claims.
    uint256 public periodLength;

    // @notice The claiming address and the timestamp of the last claim.
    mapping(address claimer => uint256 dateTime) public claims;

    /**
     * @notice Sets up the contract with the given initialization parameters.
     * @dev The initialization parameters are decoded from a bytes array into the Safe target, period length, cookie
     * amount, and cookie token.
     * The Safe target is set as both the avatar and target for the module.  This means that the module cannot be
     * chained in a series of modules.
     * A check is done to ensure the cookie amount is greater than the percentage points constant.
     * The period length, cookie amount, and cookie token are then set as per the parameters.
     * An event is emitted with the initialization parameters.
     * @param _initializationParams The initialization parameters, encoded as a bytes array.
     */
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (, uint256 _periodLength, uint256 _cookieAmount, address _cookieToken) =
            abi.decode(_initializationParams, (address, uint256, uint256, address));

        periodLength = _periodLength;
        cookieAmount = _cookieAmount;
        cookieToken = _cookieToken;

        __Ownable_init();

        emit Setup(_initializationParams);
    }

    /**
     * @notice Allows a member to make a claim and provides a reason for the claim.
     * @dev This function checks if the caller is a member and if the claim period is valid. If the requirements are
     * met, it calls the overloaded reachInJar function with the caller's address and the provided reason.
     * This function can only be called by the member themselves, and not on behalf of others.
     * @param reason The reason provided by the member for making the claim. This will be posted publicly.
     */
    function reachInJar(string calldata reason) public virtual {
        reachInJar(msg.sender, reason);
    }

    /**
     * @notice Allows a member to make a claim on behalf of another address and provides a reason for the claim.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * it updates the last claim timestamp for the caller, gives a cookie to the specified address, and posts the reason
     * for the claim. This function can be called by a member on behalf of another address, allowing for more flexible
     * distribution.
     * @param cookieMonster The address to receive the cookie.
     * @param reason The reason provided by the member for making the claim. This will be posted publicly.
     */
    function reachInJar(address cookieMonster, string calldata reason) public virtual {
        if (!_isAllowList(msg.sender)) {
            revert NOT_ALLOWED("not a member");
        }
        if (!_isValidClaimPeriod(msg.sender)) {
            revert NOT_ALLOWED("not a valid claim period");
        }

        claims[msg.sender] = block.timestamp;

        bytes32 cookieUid = _giveCookie(cookieMonster, cookieAmount, cookieToken);

        emit GiveCookie(cookieUid, cookieMonster, cookieAmount, reason);
    }

    /**
     * @notice Allows a member to assess the reason for a claim.
     * @dev The member can give a thumbs up or thumbs down to a claim reason. The assessment is posted to the Poster
     * contract. This function can only be called by a member.
     * @param cookieUid The unique identifier of the claim reason to be assessed.
     * @param message The message to be posted with the assessment.
     * @param isGood A boolean indicating whether the assessment is positive (true) or negative (false).
     */
    function assessReason(bytes32 cookieUid, string calldata message, bool isGood) public {
        if (!_isAllowList(msg.sender)) {
            revert NOT_ALLOWED("not a member");
        }

        emit AssessReason(cookieUid, message, isGood);
    }

    /**
     * @notice Checks if the user is eligible to make a claim.
     * @dev This function checks if the user is a member and if the claim period is valid by calling the isAllowList and
     * isValidClaimPeriod functions.
     * @param user The address of the user to check eligibility.
     * @return allowed A boolean indicating whether the user is eligible to make a claim.
     */
    function canClaim(address user) public view returns (bool allowed) {
        return _isAllowList(user) && _isValidClaimPeriod(user);
    }

    /**
     *
     * INTERNAL  *
     *
     */

    /**
     * @notice Checks if the claim period for the user is valid.
     * @dev Returns true if the current time minus the last claim time of the user is greater than the period length,
     * or if the user has not made a claim yet (i.e., their last claim time is zero).
     * @param user The address of the user to check the claim period.
     * @return A boolean indicating whether the claim period for the user is valid.
     */
    function _isValidClaimPeriod(address user) internal view returns (bool) {
        return block.timestamp - claims[user] >= periodLength || claims[user] == 0;
    }

    /**
     *
     * CONFIG *
     *
     */
    /**
     * @notice Allows the owner to change the configuration of the contract.
     * @dev This function can only be called by the owner of the contract. It updates the period length, cookie amount,
     * and cookie token.
     * @param _periodLength The length of the period between claims.
     * @param _cookieAmount The amount of "cookie" that can be claimed.
     * @param _cookieToken The address of the token that is being distributed, zero address for native.
     */
    function setConfig(uint256 _periodLength, uint256 _cookieAmount, address _cookieToken) public virtual onlyOwner {
        periodLength = _periodLength;
        cookieAmount = _cookieAmount;
        cookieToken = _cookieToken;
    }
}
