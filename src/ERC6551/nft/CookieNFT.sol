// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

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

    event AccountCreated(
        address account,
        address indexed cookieJar,
        uint256 indexed tokenId
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
        tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _mint(to, tokenId);

        account = IRegistry(erc6551Reg).createAccount(
            erc6551Imp,
            block.chainid,
            address(this),
            tokenId,
            block.timestamp,
            ""
        );
        cookieJar = CookieJarFactory(cookieJarSummoner).summonCookieJar(
            cookieJarImp,
            abi.encode(
                account,
                periodLength,
                cookieAmount,
                cookieToken,
                allowList
            ),
            '{"type":"CookieNFT1", "title":"Cookie NFT Gen 1", "description":"Gen1 Cookie"}'
        );

        CookieJarCore(cookieJar).transferOwnership(account);
        AccountERC6551(payable(account)).setExecutorInit(cookieJar);

        emit AccountCreated(account, cookieJar, tokenId);
    }

    /**  Constructs the tokenURI, separated out from the public function as its a big function.
     * Generates the json data URI 
     * param: _tokenId the tokenId
     */
    function _constructTokenURI(uint256 _tokenId)
        internal
        pure
        returns (string memory)
    {
        string memory _nftName = string(abi.encodePacked("CookieNFT1"));
        string memory _image = string(abi.encodePacked(
            "https://ipfs.io/ipfs/QmWn8CP5AnqmPU2zKWZesk6EFhzk5zj72mdDQEaTPmwezF/",
            Strings.toString(_tokenId)));
        string memory _animation = string(abi.encodePacked(
            "QmRjmYtyqetZgvmijsP1tKDD5dJG61vYFxThKBrUYXNZ4k?seed=",
            Strings.toString(_tokenId)));
        

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
