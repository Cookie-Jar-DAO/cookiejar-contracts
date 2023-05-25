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

contract CookieNFT is ERC721 {
    using Counters for Counters.Counter;

    address public erc6551Reg;
    address public erc6551Imp;
    address public cookieJarSummoner;
    address public cookieJarImp; // list cookie jar

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
    ) ERC721("CookieJar", "COOKIE") {
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
            '{"type":"list6551", "title":"Cookie NFT", "title":"Cookie Util NFT"}',
            cookieJarImp,
            abi.encode(
                account,
                periodLength,
                cookieAmount,
                cookieToken,
                allowList
            )
        );

        CookieJarCore(cookieJar).transferOwnership(account);
        AccountERC6551(payable(account)).setExecutorInit(cookieJar);

        emit AccountCreated(account, cookieJar, tokenId);
    }
}
