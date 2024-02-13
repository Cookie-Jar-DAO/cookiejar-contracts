// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { Module } from "@gnosis.pm/zodiac/contracts/core/Module.sol";
import { Enum } from "@gnosis.pm/safe-contracts/contracts/common/Enum.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { GiverZodiac } from "src/core/givers/GiverZodiac.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import { FactoryFriendly } from "@gnosis.pm/zodiac/contracts/factory/FactoryFriendly.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";

contract ZodiacCookieJar is CookieJarCore, GiverZodiac {
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
    function setUp(bytes memory _initializationParams)
        public
        virtual
        override(CookieJarCore, FactoryFriendly)
        initializer
    {
        (address _safeTarget) = abi.decode(_initializationParams, (address));
        super.setUp(_initializationParams);

        setAvatar(_safeTarget);
        setTarget(_safeTarget);

        transferOwnership(_safeTarget);
    }

    /**
     * @notice Transfers the specified amount of cookies to a given address.
     * @dev Calculates the sustainability fee and deducts it from the amount. Then, depending on whether the cookie is
     * an ERC20 token or ether, it executes the transfer operation. Finally, it emits a GiveCookie event.
     * @param cookieMonster The address to receive the cookie.
     * @param amount The amount of cookie to be transferred.
     */
    function giveCookie(address cookieMonster, uint256 amount) internal override returns (bytes32 cookieUid) {
        cookieUid = GiverZodiac.giveCookie(cookieMonster, amount, cookieToken);
    }
}
