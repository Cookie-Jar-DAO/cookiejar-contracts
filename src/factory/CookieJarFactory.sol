// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { ModuleProxyFactory } from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { CALL_FAILED } from "src/lib/Errors.sol";

contract CookieJarFactory is Ownable {
    ModuleProxyFactory internal moduleProxyFactory;
    
    event ModuleProxyFactorySet(address moduleProxyFactory);
    event SummonCookieJar(address cookieJar, bytes initializer, string details);
    event DonationReceived(address donationToken, uint256 donationAmount);

    address public constant SUSTAINABILITY_ADDR = 0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc;

    constructor(address newOwner) {
        transferOwnership(newOwner);
    }

    // must be called after deploy to set libraries
    function setProxyFactory(address _moduleProxyFactory) public onlyOwner {
        moduleProxyFactory = ModuleProxyFactory(_moduleProxyFactory);
        emit ModuleProxyFactorySet(_moduleProxyFactory);
    }

    //Cookie Jar init params
    // 0. address owner or safeTarget,
    // 1. uint256 _periodLength,
    // 2. uint256 _cookieAmount,
    // 4. address _cookieToken

    // Baal
    // 5. address _dao,
    // 6. uint256 _threshold,
    // 7. bool _useShares,
    // 8. bool _useLoot

    // ERC20
    // 7. address _erc20addr,
    // 8. uint256 _threshold

    // ERC721
    // 7. address _erc721addr,
    // 8. uint256 _threshold

    // Mapping
    // 7. address[] _allowlist

    // Hats
    // 7. address _hatId

    // Details
    // {
    //   "type":"Baal",
    //   "name":"Moloch Pastries",
    //   "description":"This is where you add some more content",
    //   "link":"app.daohaus.club/0x64/0x0....666"
    // }

    /**
     * @dev Deploys a new CookieJar contract using the specified singleton contract and initializer code.
     * @param _singleton The address of the singleton contract to use for the new CookieJar contract.
     * @param _initializer The initialization code for the new CookieJar contract.
     * @param _details A string describing the details of the new CookieJar contract.
     * @param donationToken The address of the token to use for donations, or address(0) for native token donations.
     * @param donationAmount The amount of ERC20 tokens to donate, or 0 for no donation. For native tokens use
     * msg.value.
     * @param _saltNonce A nonce to use for the salt in the module proxy factory.
     * @return The address of the new CookieJar contract.
     */
    function summonCookieJar(
        address _singleton,
        bytes memory _initializer,
        string memory _details,
        address donationToken,
        uint256 donationAmount,
        uint256 _saltNonce
    )
        public
        payable
        returns (address)
    {
        if (donationAmount > 0 && donationToken != address(0)) {
            if (IERC20(donationToken).transferFrom(msg.sender, address(SUSTAINABILITY_ADDR), donationAmount)) {
                emit DonationReceived(donationToken, donationAmount);
            } else {
                revert CALL_FAILED("CookieJarFactory: donation failed");
            }

            emit DonationReceived(donationToken, donationAmount);
        }

        if (msg.value > 0) {
            (bool success,) = SUSTAINABILITY_ADDR.call{ value: msg.value }("");
            if (!success) {
                revert CALL_FAILED("CookieJarFactory: donation failed");
            }
            emit DonationReceived(address(0), msg.value);
        }

        CookieJarCore cookieJar = CookieJarCore(moduleProxyFactory.deployModule(_singleton, _initializer, _saltNonce));

        emit SummonCookieJar(address(cookieJar), _initializer, _details);

        return address(cookieJar);
    }
}
