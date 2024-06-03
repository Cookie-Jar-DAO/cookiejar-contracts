// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import { IRegistry } from "src/interfaces/IERC6551Registry.sol";
import { CookieJarFactory } from "src/factory/CookieJarFactory.sol";
import { CookieJarCore } from "src/core/CookieJarCore.sol";

import { AccountERC6551 } from "src/ERC6551/erc6551/ERC6551Module.sol";
import { IAccount } from "src/interfaces/IERC6551.sol";
import { MinimalReceiver } from "src/lib/MinimalReceiver.sol";
import { Base64 } from "src/lib/Base64.sol";

import { NOT_APPROVED_OR_OWNER, INVALID_TOKEN_ID } from "src/lib/Errors.sol";

contract CookieNFT is ERC721 {
    using Counters for Counters.Counter;

    address public erc6551Reg;
    address public erc6551Imp;
    address public cookieJarSummoner;

    Counters.Counter private _tokenIdCounter;

    struct Cookie {
        address cookieJar;
        uint256 periodLength;
        uint256 cookieAmount;
        address cookieToken;
    }

    mapping(uint256 => Cookie) public cookies;

    event AccountCreated(address indexed account, address indexed cookieJar, uint256 tokenId);

    constructor(
        address _erc6551Reg,
        address _erc6551Imp,
        address _cookieJarSummoner
    )
        ERC721("CookieJar Number 1", "COOKIE1")
    {
        erc6551Reg = _erc6551Reg;
        erc6551Imp = _erc6551Imp;
        cookieJarSummoner = _cookieJarSummoner;
    }

    function cookieMint(
        address cookieJarImp,
        bytes memory _initializer,
        string memory details,
        address donationToken,
        uint256 donationAmount
    )
        public
        payable
        returns (address account, address cookieJar, uint256 tokenId)
    {
        // 0. address owner or safeTarget,
        // 1. uint256 _periodLength,
        // 2. uint256 _cookieAmount,
        // 4. address _cookieToken
        (address to, uint256 periodLength, uint256 cookieAmount, address cookieToken) =
            abi.decode(_initializer, (address, uint256, uint256, address));

        if (msg.value > 0) {
            payable(address(this)).transfer(msg.value);
        }
        _tokenIdCounter.increment();
        tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);

        account =
            IRegistry(erc6551Reg).createAccount(erc6551Imp, block.chainid, address(this), tokenId, block.timestamp, "");

        assembly {
            // Load the first word from `data` (first 32 bytes)
            let word := mload(add(_initializer, 32))

            // Replace the first 20 bytes of this word with the address
            // Solidity stores `bytes` objects with an additional length field, so we skip the first 12 bytes
            word := or(and(word, 0xffffffffffffffffffffffff0000000000000000000000000000000000000000), account)

            // Store the modified word back into `data`
            mstore(add(_initializer, 32), word)
        }

        bytes memory initializer = abi.encodeWithSignature("setUp(bytes)", _initializer);
        uint256 saltNonce = 1_234_567_890; // hard code saltNonce for now
        cookieJar = CookieJarFactory(cookieJarSummoner).summonCookieJar(
            cookieJarImp, initializer, details, donationToken, donationAmount, saltNonce
        );

        AccountERC6551(payable(account)).setExecutorInit(cookieJar);

        cookies[tokenId] = Cookie(cookieJar, periodLength, cookieAmount, cookieToken);

        emit AccountCreated(account, cookieJar, tokenId);
    }

    function _cookieBalance(uint256 tokenId) internal view returns (uint256) {
        if (cookies[tokenId].cookieToken == address(0)) {
            return address(this).balance;
        } else {
            return ERC20(cookies[tokenId].cookieToken).balanceOf(cookies[tokenId].cookieJar);
        }
    }

    function _cookieDecimal(uint256 tokenId) internal view returns (uint256) {
        if (cookies[tokenId].cookieToken == address(0)) {
            return 18;
        } else {
            return ERC20(cookies[tokenId].cookieToken).decimals();
        }
    }

    function _cookieSymbol(uint256 tokenId) internal view returns (string memory) {
        if (cookies[tokenId].cookieToken == address(0)) {
            return "eth";
        } else {
            return ERC20(cookies[tokenId].cookieToken).symbol();
        }
    }

    /**
     * Constructs the tokenURI, separated out from the public function as its a big function.
     * Generates the json data URI
     * param: _tokenId the tokenId
     */
    function _constructTokenURI(uint256 _tokenId) internal view returns (string memory) {
        string memory _nftName = string(abi.encodePacked("CookieNFT1"));
        string memory _image = string(
            abi.encodePacked(
                "ipfs://Qme4HsmWQSmShQ3dDPZGD8A5kyTPceTEP5dVkWnsMHhC2Z/", Strings.toString(_tokenId), ".png"
            )
        );
        string memory _animation = string(
            abi.encodePacked(
                "ipfs://QmUvndsEv47bpwH8dLr5j8Cn24fXRyZKZubx2oHUQU4n7Q?seed=",
                Strings.toString(_tokenId),
                "&balance=",
                Strings.toString(_cookieBalance(_tokenId)),
                "&period=",
                Strings.toString(cookies[_tokenId].periodLength),
                "&amount=",
                Strings.toString(cookies[_tokenId].cookieAmount),
                "&symbol=",
                _cookieSymbol(_tokenId),
                "&decimals=",
                Strings.toString(_cookieDecimal(_tokenId))
            )
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name":"',
                            _nftName,
                            '", "image":"',
                            _image,
                            '", "animation_url":"',
                            _animation,
                            // Todo something clever
                            '", "description": "Cookie Jar NFT", "attributes": [{"trait_type": "base", "value": "cookie"}]}'
                        )
                    )
                )
            )
        );
    }

    /* Returns the json data associated with this token ID
     * param _tokenId the token ID
     */
    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        if (!_exists(_tokenId)) {
            revert INVALID_TOKEN_ID(_tokenId);
        }
        return string(_constructTokenURI(_tokenId));
    }

    function burn(uint256 _tokenId) public {
        if (!_isApprovedOrOwner(_msgSender(), _tokenId)) {
            revert NOT_APPROVED_OR_OWNER();
        }
        _burn(_tokenId);
    }
}
