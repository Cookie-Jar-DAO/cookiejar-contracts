// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

interface ICookieJar {
    /// @dev Emitted when the contract is set up.
    /// @param initializationParams The parameters used for initialization.
    event Setup(bytes initializationParams);

    /// @dev Emitted when a "cookie" is given to an address.
    /// @param cookieMonster The address receiving the cookie.
    /// @param amount The amount of cookie given.
    event GiveCookie(address indexed cookieMonster, uint256 amount);

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
     *  // TODO: add initializer to this contract
     */
    function setUp(bytes memory _initializationParams) external;

    /**
     * @notice Allows owner to change congiguration.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * @param _periodLength The length of the period between claims.
     * @param _cookieAmount The amount of "cookie" that can be claimed.
     * @param _cookieToken The address of the token that is being distributed, zero address for native.
     */
    function setConfig(uint256 _periodLength, uint256 _cookieAmount, address _cookieToken) external;

    /**
     * @notice Allows a member to make a claim and provides a reason for the claim.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * it updates the last claim timestamp for the caller, gives a cookie to the caller, and posts the reason for the
     * claim.
     * This function can only be called by the member themselves, and not on behalf of others.
     * @param _reason The reason provided by the member for making the claim. This will be posted publicly.
     */

    function reachInJar(string calldata _reason) external;

    /**
     * @notice Allows a member to make a claim on behalf of another address and provides a reason for the claim.
     * @dev Checks if the caller is a member and if the claim period is valid. If the requirements are met,
     * it updates the last claim timestamp for the caller, gives a cookie to the specified address, and posts the reason
     * for the claim.
     * This function can be called by a member on behalf of another address, allowing for more flexible distribution.
     * @param cookieMonster The address to receive the cookie.
     * @param _reason The reason provided by the member for making the claim. This will be posted publicly.
     */
    function reachInJar(address cookieMonster, string calldata _reason) external;

    /**
     * @notice Allows a member to assess the reason for a claim.
     * @dev The member can give a thumbs up or thumbs down to a claim reason. The assessment is posted to the Poster
     * contract.
     * @param _uid The unique identifier of the claim reason to be assessed.
     * @param _isGood A boolean indicating whether the assessment is positive (true) or negative (false).
     */
    function assessReason(string calldata _uid, bool _isGood) external;

    /**
     * @notice Checks if the caller is eligible to make a claim.
     * @dev Calls the isAllowList and isValidClaimPeriod functions to check if the caller is a member and within the
     * valid claim period.
     * @return A boolean indicating whether the caller is eligible to make a claim.
     */
    function canClaim(address user) external view returns (bool);
}
