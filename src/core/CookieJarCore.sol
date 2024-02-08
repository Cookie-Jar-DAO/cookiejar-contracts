// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { ICookieJar } from "src/interfaces/ICookieJar.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/contracts/access/OwnableUpgradeable.sol";
import { Initializable } from "@openzeppelin/contracts-upgradeable/contracts/proxy/utils/Initializable.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

abstract contract CookieJarCore is Initializable, OwnableUpgradeable, ICookieJar {
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
    function setUp(bytes memory _initializationParams) public virtual {
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
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * it updates the last claim timestamp for the caller, gives a cookie to the caller, and posts the reason for the
     * claim.
     * This function can only be called by the member themselves, and not on behalf of others.
     * @param reason The reason provided by the member for making the claim. This will be posted publicly.
     */
    function reachInJar(string calldata reason) public virtual {
        require(isAllowList(msg.sender), "not a member");
        require(isValidClaimPeriod(msg.sender), "not a valid claim period");

        reachInJar(msg.sender, reason);
    }

    /**
     * @notice Allows a member to make a claim on behalf of another address and provides a reason for the claim.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * it updates the last claim timestamp for the caller, gives a cookie to the specified address, and posts the reason
     * for the claim.
     * This function can be called by a member on behalf of another address, allowing for more flexible distribution.
     * @param cookieMonster The address to receive the cookie.
     * @param reason The reason provided by the member for making the claim. This will be posted publicly.
     */
    function reachInJar(address cookieMonster, string calldata reason) public virtual {
        require(isAllowList(msg.sender), "not a member");
        require(isValidClaimPeriod(msg.sender), "not a valid claim period");

        claims[msg.sender] = block.timestamp;

        bytes32 cookieUid = giveCookie(cookieMonster, cookieAmount);

        emit GiveCookie(cookieUid, cookieMonster, cookieAmount, reason);
    }

    /**
     * @notice Transfers the specified amount of cookies to a given address.
     * @dev Calculates the sustainability fee and deducts it from the amount. Then, depending on whether the cookie is
     * an ERC20 token or ether, it executes the transfer operation. Finally, it emits a GiveCookie event.
     * @param cookieMonster The address to receive the cookie.
     * @param amount The amount of cookie to be transferred.
     * @return cookieUid The unique identifier of the cookie.
     */
    function giveCookie(address cookieMonster, uint256 amount) internal virtual returns (bytes32 cookieUid) { }

    /**
     * @notice Allows a member to assess the reason for a claim.
     * @dev The member can give a thumbs up or thumbs down to a claim reason. The assessment is posted to the Poster
     * contract.
     * @param cookieUid The unique identifier of the claim reason to be assessed.
     * @param isGood A boolean indicating whether the assessment is positive (true) or negative (false).
     * @param message The message to be posted with the assessment.
     *
     */
    function assessReason(bytes32 cookieUid, string calldata message, bool isGood) public {
        require(isAllowList(msg.sender), "not a member");

        emit AssessReason(cookieUid, message, isGood);
    }

    /**
     * @notice Checks if the caller is eligible to make a claim.
     * @dev Calls the isAllowList and isValidClaimPeriod functions to check if the caller is a member and within the
     * valid claim period.
     * @return allowed A boolean indicating whether the caller is eligible to make a claim.
     */
    function canClaim(address user) public view returns (bool allowed) {
        return isAllowList(user) && isValidClaimPeriod(user);
    }

    /**
     * @notice Checks if the caller is a member.
     * @dev Always returns true in this contract, but is expected to be overridden in a derived contract.
     * @return A boolean indicating whether the caller is a member.
     */
    function isAllowList(address /*user*/ ) public view virtual returns (bool) {
        return true;
    }

    /**
     *
     * INTERNAL  *
     *
     */

    /**
     * @notice Checks if the claim period for the caller is valid.
     * @dev Returns true if the current time minus the last claim time of the caller is greater than the period length,
     * or if the caller has not made a claim yet (i.e., their last claim time is zero).
     * @return A boolean indicating whether the claim period for the caller is valid.
     */
    function isValidClaimPeriod(address user) internal view returns (bool) {
        return block.timestamp - claims[user] >= periodLength || claims[user] == 0;
    }

    /**
     *
     * CONFIG *
     *
     */
    /**
     * @notice Allows owner to change congiguration.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
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
