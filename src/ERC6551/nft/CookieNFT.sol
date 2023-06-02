// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import {IRegistry} from "src/interfaces/IERC6551Registry.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {CookieJarCore} from "src/core/CookieJarCore.sol";

import {AccountERC6551} from "src/ERC6551/erc6551/ERC6551Module.sol";
import {IAccount} from "src/interfaces/IERC6551.sol";
import {MinimalReceiver} from "src/lib/MinimalReceiver.sol";
import {Base64} from "src/lib/Base64.sol";

contract CookieNFT is ERC721 {
    using Counters for Counters.Counter;

    address public erc6551Reg;
    address public erc6551Imp;
    address public cookieJarSummoner;
    address public cookieJarImp; // list cookie jar
    uint256 public cap = 20;

    Counters.Counter private _tokenIdCounter;

    struct Cookie {
        address cookieJar;
        uint256 periodLength;
        uint256 cookieAmount;
        address cookieToken;
    }

    mapping(uint256 => Cookie) public cookies;

    event AccountCreated(
        address indexed account,
        address indexed cookieJar,
        uint256 tokenId
    );

    constructor(
        address _erc6551Reg,
        address _erc6551Imp,
        address _cookieJarSummoner,
        address _cookieJarImp
    ) ERC721("CookieJar Number 1", "COOKIE1") {
        erc6551Reg = _erc6551Reg;
        erc6551Imp = _erc6551Imp;
        cookieJarSummoner = _cookieJarSummoner;
        cookieJarImp = _cookieJarImp;
    }

    function cookieMint(
        address to,
        uint256 periodLength,
        uint256 cookieAmount,
        address cookieToken,
        address[] memory allowList
    ) public returns (address account, address cookieJar, uint256 tokenId) {
        require(
            _tokenIdCounter.current() <= cap,
            "CookieNFT: cap reached, no more cookies"
        );
        _tokenIdCounter.increment();
        tokenId = _tokenIdCounter.current();
        _mint(to, tokenId);

        account = IRegistry(erc6551Reg).createAccount(
            erc6551Imp,
            block.chainid,
            address(this),
            tokenId,
            block.timestamp,
            ""
        );
        bytes memory initializerParams =
            abi.encode(
                account,
                periodLength,
                cookieAmount,
                cookieToken,
                allowList);
        bytes memory initializer = abi.encodeWithSignature("setUp(bytes)", initializerParams);
        string memory details = '{"type":"6551", "title":"Cookie NFT Gen 1", "description":"Gen1 Cookie", "link":""}';
        uint256 saltNonce = 1_234_567_890;
        cookieJar = CookieJarFactory(cookieJarSummoner).summonCookieJar(
            cookieJarImp,
            initializer,
            details,
            saltNonce
        );

        // CookieJarCore(cookieJar).transferOwnership(account);
        AccountERC6551(payable(account)).setExecutorInit(cookieJar);

        cookies[tokenId] = Cookie(
            cookieJar,
            periodLength,
            cookieAmount,
            cookieToken
        );

        emit AccountCreated(account, cookieJar, tokenId);
    }

    function _cookieBalance(uint256 tokenId) internal view returns (uint256) {
        if(cookies[tokenId].cookieToken == address(0)) {
            return address(this).balance;
        } else {
            return ERC20(cookies[tokenId].cookieToken).balanceOf(
                cookies[tokenId].cookieJar
            );
        }
    }

    function _cookieDecimal(uint256 tokenId) internal view returns (uint256) {
        if(cookies[tokenId].cookieToken == address(0)) {
            return 18;
        } else {
            return ERC20(cookies[tokenId].cookieToken).decimals();
        }
    }

    function _cookieSymbol(uint256 tokenId) internal view returns (string memory) {
        if(cookies[tokenId].cookieToken == address(0)) {
            return "eth";
        } else {
            return ERC20(cookies[tokenId].cookieToken).symbol();
        }
    }

    /**  Constructs the tokenURI, separated out from the public function as its a big function.
     * Generates the json data URI 
     * param: _tokenId the tokenId
     */
    function _constructTokenURI(uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        string memory _nftName = string(abi.encodePacked("CookieNFT1"));
        string memory _image = string(abi.encodePacked(
            "ipfs://Qme4HsmWQSmShQ3dDPZGD8A5kyTPceTEP5dVkWnsMHhC2Z/",
            Strings.toString(_tokenId),".png"));
        string memory _animation = string(abi.encodePacked(
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
            ));
        

        return
            string(
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
    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(_constructTokenURI(_tokenId));
    }
}
