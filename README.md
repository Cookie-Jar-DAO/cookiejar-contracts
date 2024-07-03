# CookieJar

The cookie jar is a protocol for distributing tokens to users over time. It is designed to be flexible and extensible,
allowing developers to create custom cookie jars with different distribution rules and token types.

The CookieJar protocol supports various types of distributions, including Baal Cookie Jars for distributing tokens to
`Moloch DAO` members, `ERC20` and `ERC721` Cookie Jars for distributing tokens based on users' token balances, `List`
Cookie Jars for
distributing tokens to a pre-approved list of users, `Open` Cookie Jars for distributing tokens to any user who claims
them, and [`Hats`](https://www.hatsprotocol.xyz/) Cookie Jars for distributing tokens based on users' Hat wearingness.

# Architecture

The protocol consists of a set of composable modules to establish multiple types of cookie jars. The core module is
the `CookieJarCore` contract that represents the cookie jar which configures the rate limiting and ownership. By adding
a `Giver` module tokens held by the cookie jar can be distributed from a `6551` smart wallet or a `Safe` contract. Based
on the allowlist, users can claim tokens from the cookie jar.

## Rate limiting

By defining the `amount` and `period` of the cookie jar, the rate of token distribution can be controlled. The `amount`
is the number of tokens distributed per `period`. The `period` is the time interval in seconds between each
distribution.

## Allow lists

Allow lists gate access to the cookie jar. Currently we support `Baal` (MolochV3), `ERC20`, `ERC721`, `List`, `Open`,
and `Hats` gating.

Baal cookie jars are gated by the MolochV3 DAO. The `ERC20` cookie jar is gated by the balance of an ERC20 token.
The `ERC721` cookie jar is gated by the balance of an ERC721 token. The `List` cookie jar is gated by a list of
addresses. The `Open` cookie jar is open to all addresses. The `Hats` cookie jar is gated by the HatID.

## Givers

Givers are the source of tokens for the cookie jar. Currently we support `6551` and `Safe` givers.

The `6551` giver is a smart wallet that holds tokens. The `Safe` giver is a Safe contract that holds tokens.

## Example happy flow

```mermaid
sequenceDiagram
    participant User as Allowlisted user
    participant CJC as Cookie Jar
    participant GB as Giver
    participant AB as Allowlist
    User->>CJC: reachInJar("I like cookies")
    CJC->>AB: _isAllowList(User)
    AB-->>CJC: true
    CJC->>CJC: _isValidClaimPeriod(User)
    CJC-->>CJC: true
    CJC->>GB: _giveCookie(User, cookieAmount, cookieToken)
    GB-->>CJC: cookieUid
    CJC-->>User: emit GiveCookie(cookieUid, User, cookieAmount, reason)
```

# Deployment

The following table lists the addresses of the deployed contracts:

## Arbitrum

| Setup              | Address                                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Cookie Jar Factory | [`0x4c941cafac0b6d67a6c4ee5399927aa889aab780`](https://arbiscan.io/address/0x4c941cafac0b6d67a6c4ee5399927aa889aab780) |

| Contract          | Address                                                                                                                         |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NFT               | [`0x9fcbcda3decd4a0d6dd7347755762439aa6c1832`](https://arbiscan.io/address/0x9fcbcda3decd4a0d6dd7347755762439aa6c1832) |
| Baal Cookie Jar   | [`0x8b1ac5a3fea9eebbece920c98171d19e0b048029`](https://arbiscan.io/address/0x8b1ac5a3fea9eebbece920c98171d19e0b048029) |
| ERC20 Cookie Jar  | [`0x0b963b444adb4c0056647377149ea33ff2bdc077`](https://arbiscan.io/address/0x0b963b444adb4c0056647377149ea33ff2bdc077) |
| ERC721 Cookie Jar | [`0xceb1a0695db4a521573439eabe76caacf82c90ed`](https://arbiscan.io/address/0xceb1a0695db4a521573439eabe76caacf82c90ed) |
| List Cookie Jar   | [`0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe`](https://arbiscan.io/address/0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe) |
| Open Cookie Jar   | [`0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797`](https://arbiscan.io/address/0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797) |
| Hats Cookie Jar   | [`0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a`](https://arbiscan.io/address/0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a) |

| Safe Module Contracts    | Address                                                                                                                         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Zodiac Baal Cookie Jar   | [`0xe44a0e469667e5ea677721746b0439fe70434b6f`](https://arbiscan.io/address/0xe44a0e469667e5ea677721746b0439fe70434b6f) |
| Zodiac ERC20 Cookie Jar  | [`0x008138711b2dff79d45e1ee8ad29b03c3c907b20`](https://arbiscan.io/address/0x008138711b2dff79d45e1ee8ad29b03c3c907b20) |
| Zodiac ERC721 Cookie Jar | [`0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c`](https://arbiscan.io/address/0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c) |
| Zodiac List Cookie Jar   | [`0x667afc73fbd1fdd2de327456a2473a48eee04e78`](https://arbiscan.io/address/0x667afc73fbd1fdd2de327456a2473a48eee04e78) |
| Zodiac Open Cookie Jar   | [`0x8b5e3f92a992752ddf270f43b35d8f8123560e03`](https://arbiscan.io/address/0x8b5e3f92a992752ddf270f43b35d8f8123560e03) |
| Zodiac Hats Cookie Jar   | [`0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768`](https://arbiscan.io/address/0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768) |

## Base

| Setup              | Address                                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Cookie Jar Factory | [`0x9fcbcda3decd4a0d6dd7347755762439aa6c1832`](https://basescan.org/address/0x9fcbcda3decd4a0d6dd7347755762439aa6c1832) |

| Contract          | Address                                                                                                                         |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NFT               | [`0x9fcbcda3decd4a0d6dd7347755762439aa6c1832`](https://basescan.org/address/0x9fcbcda3decd4a0d6dd7347755762439aa6c1832) |
| Baal Cookie Jar   | [`0x8b1ac5a3fea9eebbece920c98171d19e0b048029`](https://basescan.org/address/0x8b1ac5a3fea9eebbece920c98171d19e0b048029) |
| ERC20 Cookie Jar  | [`0x0b963b444adb4c0056647377149ea33ff2bdc077`](https://basescan.org/address/0x0b963b444adb4c0056647377149ea33ff2bdc077) |
| ERC721 Cookie Jar | [`0xceb1a0695db4a521573439eabe76caacf82c90ed`](https://basescan.org/address/0xceb1a0695db4a521573439eabe76caacf82c90ed) |
| List Cookie Jar   | [`0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe`](https://basescan.org/address/0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe) |
| Open Cookie Jar   | [`0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797`](https://basescan.org/address/0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797) |
| Hats Cookie Jar   | [`0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a`](https://basescan.org/address/0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a) |

| Safe Module Contracts    | Address                                                                                                                         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Zodiac Baal Cookie Jar   | [`0xe44a0e469667e5ea677721746b0439fe70434b6f`](https://basescan.org/address/0xe44a0e469667e5ea677721746b0439fe70434b6f) |
| Zodiac ERC20 Cookie Jar  | [`0x008138711b2dff79d45e1ee8ad29b03c3c907b20`](https://basescan.org/address/0x008138711b2dff79d45e1ee8ad29b03c3c907b20) |
| Zodiac ERC721 Cookie Jar | [`0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c`](https://basescan.org/address/0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c) |
| Zodiac List Cookie Jar   | [`0x667afc73fbd1fdd2de327456a2473a48eee04e78`](https://basescan.org/address/0x667afc73fbd1fdd2de327456a2473a48eee04e78) |
| Zodiac Open Cookie Jar   | [`0x8b5e3f92a992752ddf270f43b35d8f8123560e03`](https://basescan.org/address/0x8b5e3f92a992752ddf270f43b35d8f8123560e03) |
| Zodiac Hats Cookie Jar   | [`0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768`](https://basescan.org/address/0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768) |


## Gnosis

| Setup              | Address                                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Cookie Jar Factory | [`0x4c941cafac0b6d67a6c4ee5399927aa889aab780`](https://gnosisscan.io/address/0x4c941cafac0b6d67a6c4ee5399927aa889aab780) |

| Contract          | Address                                                                                                                         |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NFT               | [`0xff15b1de4921e8832f688f9660c97454ea448a16`](https://gnosisscan.io/address/0xff15b1de4921e8832f688f9660c97454ea448a16) |
| Baal Cookie Jar   | [`0x8b1ac5a3fea9eebbece920c98171d19e0b048029`](https://gnosisscan.io/address/0x8b1ac5a3fea9eebbece920c98171d19e0b048029) |
| ERC20 Cookie Jar  | [`0x0b963b444adb4c0056647377149ea33ff2bdc077`](https://gnosisscan.io/address/0x0b963b444adb4c0056647377149ea33ff2bdc077) |
| ERC721 Cookie Jar | [`0xceb1a0695db4a521573439eabe76caacf82c90ed`](https://gnosisscan.io/address/0xceb1a0695db4a521573439eabe76caacf82c90ed) |
| List Cookie Jar   | [`0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe`](https://gnosisscan.io/address/0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe) |
| Open Cookie Jar   | [`0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797`](https://gnosisscan.io/address/0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797) |
| Hats Cookie Jar   | [`0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a`](https://gnosisscan.io/address/0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a) |

| Safe Module Contracts    | Address                                                                                                                         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Zodiac Baal Cookie Jar   | [`0xe44a0e469667e5ea677721746b0439fe70434b6f`](https://gnosisscan.io/address/0xe44a0e469667e5ea677721746b0439fe70434b6f) |
| Zodiac ERC20 Cookie Jar  | [`0x008138711b2dff79d45e1ee8ad29b03c3c907b20`](https://gnosisscan.io/address/0x008138711b2dff79d45e1ee8ad29b03c3c907b20) |
| Zodiac ERC721 Cookie Jar | [`0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c`](https://gnosisscan.io/address/0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c) |
| Zodiac List Cookie Jar   | [`0x667afc73fbd1fdd2de327456a2473a48eee04e78`](https://gnosisscan.io/address/0x667afc73fbd1fdd2de327456a2473a48eee04e78) |
| Zodiac Open Cookie Jar   | [`0x8b5e3f92a992752ddf270f43b35d8f8123560e03`](https://gnosisscan.io/address/0x8b5e3f92a992752ddf270f43b35d8f8123560e03) |
| Zodiac Hats Cookie Jar   | [`0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768`](https://gnosisscan.io/address/0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768) |


## Optimism

| Setup              | Address                                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Cookie Jar Factory | [`0x4c941cafac0b6d67a6c4ee5399927aa889aab780`](https://optimistic.etherscan.io/address/0x4c941cafac0b6d67a6c4ee5399927aa889aab780) |

| Contract          | Address                                                                                                                         |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NFT               | [`0xca1034ac73eb862fb6d436f9fe5954766243884c`](https://optimistic.etherscan.io/address/0xca1034ac73eb862fb6d436f9fe5954766243884c) |
| Baal Cookie Jar   | [`0x8b1ac5a3fea9eebbece920c98171d19e0b048029`](https://optimistic.etherscan.io/address/0x8b1ac5a3fea9eebbece920c98171d19e0b048029) |
| ERC20 Cookie Jar  | [`0x0b963b444adb4c0056647377149ea33ff2bdc077`](https://optimistic.etherscan.io/address/0x0b963b444adb4c0056647377149ea33ff2bdc077) |
| ERC721 Cookie Jar | [`0xceb1a0695db4a521573439eabe76caacf82c90ed`](https://optimistic.etherscan.io/address/0xceb1a0695db4a521573439eabe76caacf82c90ed) |
| List Cookie Jar   | [`0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe`](https://optimistic.etherscan.io/address/0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe) |
| Open Cookie Jar   | [`0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797`](https://optimistic.etherscan.io/address/0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797) |
| Hats Cookie Jar   | [`0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a`](https://optimistic.etherscan.io/address/0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a) |

| Safe Module Contracts    | Address                                                                                                                         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Zodiac Baal Cookie Jar   | [`0xe44a0e469667e5ea677721746b0439fe70434b6f`](https://optimistic.etherscan.io/address/0xe44a0e469667e5ea677721746b0439fe70434b6f) |
| Zodiac ERC20 Cookie Jar  | [`0x008138711b2dff79d45e1ee8ad29b03c3c907b20`](https://optimistic.etherscan.io/address/0x008138711b2dff79d45e1ee8ad29b03c3c907b20) |
| Zodiac ERC721 Cookie Jar | [`0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c`](https://optimistic.etherscan.io/address/0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c) |
| Zodiac List Cookie Jar   | [`0x667afc73fbd1fdd2de327456a2473a48eee04e78`](https://optimistic.etherscan.io/address/0x667afc73fbd1fdd2de327456a2473a48eee04e78) |
| Zodiac Open Cookie Jar   | [`0x8b5e3f92a992752ddf270f43b35d8f8123560e03`](https://optimistic.etherscan.io/address/0x8b5e3f92a992752ddf270f43b35d8f8123560e03) |
| Zodiac Hats Cookie Jar   | [`0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768`](https://optimistic.etherscan.io/address/0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768) |


## Sepolia

| Setup              | Address                                                                                                                         |
|--------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Cookie Jar Factory | [`0x4c941cafac0b6d67a6c4ee5399927aa889aab780`](https://sepolia.etherscan.io/address/0x4c941cafac0b6d67a6c4ee5399927aa889aab780) |

| Contract          | Address                                                                                                                         |
|-------------------|---------------------------------------------------------------------------------------------------------------------------------|
| NFT               | [`0x02a79751c926e4172d715b7bcee2c7710fc0ad71`](https://sepolia.etherscan.io/address/0x02a79751c926e4172d715b7bcee2c7710fc0ad71) |
| Baal Cookie Jar   | [`0x8b1ac5a3fea9eebbece920c98171d19e0b048029`](https://sepolia.etherscan.io/address/0x8b1ac5a3fea9eebbece920c98171d19e0b048029) |
| ERC20 Cookie Jar  | [`0x0b963b444adb4c0056647377149ea33ff2bdc077`](https://sepolia.etherscan.io/address/0x0b963b444adb4c0056647377149ea33ff2bdc077) |
| ERC721 Cookie Jar | [`0xceb1a0695db4a521573439eabe76caacf82c90ed`](https://sepolia.etherscan.io/address/0xceb1a0695db4a521573439eabe76caacf82c90ed) |
| List Cookie Jar   | [`0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe`](https://sepolia.etherscan.io/address/0xc4a4e1f354f6b04a429c6436cdebb5fe0aa071fe) |
| Open Cookie Jar   | [`0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797`](https://sepolia.etherscan.io/address/0x6baf21f2179c98a503193d4f09ad3cb0c3bdb797) |
| Hats Cookie Jar   | [`0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a`](https://sepolia.etherscan.io/address/0x2b5a30b2e626ba38f2a910cb4fc20e12522eb76a) |

| Safe Module Contracts    | Address                                                                                                                         |
|--------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Zodiac Baal Cookie Jar   | [`0xe44a0e469667e5ea677721746b0439fe70434b6f`](https://sepolia.etherscan.io/address/0xe44a0e469667e5ea677721746b0439fe70434b6f) |
| Zodiac ERC20 Cookie Jar  | [`0x008138711b2dff79d45e1ee8ad29b03c3c907b20`](https://sepolia.etherscan.io/address/0x008138711b2dff79d45e1ee8ad29b03c3c907b20) |
| Zodiac ERC721 Cookie Jar | [`0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c`](https://sepolia.etherscan.io/address/0x997e3fd50a40ce41b68b2eb9d5d5c5cbd3d64f9c) |
| Zodiac List Cookie Jar   | [`0x667afc73fbd1fdd2de327456a2473a48eee04e78`](https://sepolia.etherscan.io/address/0x667afc73fbd1fdd2de327456a2473a48eee04e78) |
| Zodiac Open Cookie Jar   | [`0x8b5e3f92a992752ddf270f43b35d8f8123560e03`](https://sepolia.etherscan.io/address/0x8b5e3f92a992752ddf270f43b35d8f8123560e03) |
| Zodiac Hats Cookie Jar   | [`0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768`](https://sepolia.etherscan.io/address/0x7de5cc168dfee378c5c2a8ecaf529cbea0bb0768) |

## 6551 Tokenbound Registry

The Tokenbound Registry for 6551 tokens is deployed on the following chains:

| Chain    | Address                                      |
|----------|----------------------------------------------|
| Arbitrum | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Base     | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Gnosis   | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Optimism | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Sepolia  | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |

## Sustainability Safe

To fund further development we implemented sustainability fees when claiming cookies and the option to donate native
tokens or ERC20s when summoning a CookieJar. Donations are optional; summon the CookieJar with `donationToken` =
address(0) and `donationAmount` = 0;

| Chain    | Address                                      |
|----------|----------------------------------------------|
| Arbitrum | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Base     | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Gnosis   | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Mainnet  | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Optimism | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |

## Module Proxy Factory

The Module Proxy Factory is deployed on the following chains:

| Chain    | Address                                      |
|----------|----------------------------------------------|
| Arbitrum | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |
| Base     | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |
| Gnosis   | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |
| Mainnet  | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |
| Optimism | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |
| Sepolia  | `0xC22834581EbC8527d974F8a1c97E1bEA4EF910BC` |

## Installation

To run the CookieJar contracts, you will need to have foundry installed on your system. You can then run the following
command:

`forge compile`

And you should get no errors

## Testing

To run the tests for the Cookie Jar contracts, you can run the following command:

`forge test`

## Jar features

### Cookie Jar Initialization Parameters

The Cookie Jar contract can be initialized with a set of parameters that define the behavior of the contract. The
parameters are passed to the contract's constructor as an array of values.

The parameters are different depending on the type of Cookie Jar being created. There are three types of Cookie Jars:
Baal, ERC20, and ERC721. The parameters for each type of Cookie Jar are as follows:

#### Baal Cookie Jar

| Parameter | Type    | Description                                                |
|-----------|---------|------------------------------------------------------------|
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | address | The address of the DAO contract.                           |
| 5         | uint256 | The threshold for tokens in the DAO.                       |
| 6         | bool    | Whether to use shareTokens.                                |
| 7         | bool    | Whether to use lootTokens.                                 |

#### ERC20 Cookie Jar

| Parameter | Type    | Description                                                |
|-----------|---------|------------------------------------------------------------|
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | address | The address of the ERC20 token contract.                   |
| 5         | uint256 | The threshold for balance in the ERC20 token contract.     |

#### ERC721 Cookie Jar

| Parameter | Type    | Description                                                |
|-----------|---------|------------------------------------------------------------|
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | address | The address of the ERC721 token contract.                  |
| 5         | uint256 | The threshold for balance in the ERC721 token contract.    |

#### Hats Cookie Jar

| Parameter | Type    | Description                                                |
|-----------|---------|------------------------------------------------------------|
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | uint256 | The HatID to check eligibility against                     |

#### Mapping Cookie Jar

| Parameter | Type      | Description                                                |
|-----------|-----------|------------------------------------------------------------|
| 0         | address   | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256   | The length of the period for the Cookie Jar.               |
| 2         | uint256   | The amount of cookies to be distributed per period.        |
| 3         | address   | The address of the cookie token contract.                  |
| 4         | address[] | The list of addresses allowed to claim cookies.            |

The parameters for each type of Cookie Jar are passed to the summonCookieJar function as a byte array. The byte array is
constructed by encoding the parameters in the order listed above.

### Generating IDs

The CookieUtils library provides utility functions for generating unique identifiers (UIDs) for cookies and cookie jars.

#### getCookieJarUid

The getCookieJarUid function is used to generate a unique identifier for a cookie jar. The function takes an address
parameter cookieJarAddr and returns a string that represents the unique identifier.

For example, to generate a unique identifier for a new cookie jar, you can call the getCookieJarUid function with the
address of the new cookie jar as the input parameter:

```js
    function getCookieJarUid(address

cookieJarAddr
)
internal
view
returns(string
memory
)
{
    return string(abi.encodePacked(Strings.toHexString(uint160(cookieJarAddr)), Strings.toHexString(block.chainid)));
}
```

The unique identifier is generated by concatenating the hexadecimal representation of the cookieJarAddr parameter with
the hexadecimal representation of the current blockchain chain ID.

#### getCookieUid

The getCookieUid function is used to generate a unique identifier for a cookie. The function takes a string parameter
cookieJarUid and returns a string that represents the unique identifier.

Similarly, to generate a unique identifier for a new cookie, you can call the getCookieUid function with the unique
identifier of the cookie jar as the input parameter:

```js
   function getCookieUid(string

memory
cookieJarUid
)
internal
view
returns(string
memory
)
{
    return bytes32ToString(keccak256(abi.encodePacked(cookieJarUid, msg.sender, block.timestamp)));
}
```

The unique identifier is generated by concatenating the cookieJarUid parameter with the hexadecimal representation of
the current user's address and the current block timestamp.

### Details schema

```json
{
  "type": "Baal",
  "name": "Moloch Pastries",
  "description": "This is where you add some more content",
  "link": "app.daohaus.club/0x64/0x0....666"
}
```

### Post Claim Reason

The post claim reason event is used to store a reason for a claim made by a user. The event has the following schema:

```json
{
  "tag": "CookieJar.<jar_uid>.reason.<cookie_uid>",
  "reason": "...reason...",
  "link": "app.daohaus.club/0x64/0x0....666"
}
```

- tag: A string that identifies the type of event and the unique identifier of the CookieJar contract and the cookie.
- content: A string that contains the reason for the claim.

### Assess Reason

The assess reason event is used to store an assessment of a reason for a claim made by a user. The event has the
following schema:

```json
{
  "tag": "CookieJar.<jar_uid>.reaction.<cookie_uid>",
  "content": "...reason...",
  "link": "app.daohaus.club/0x64/0x0....666"
}
```

- tag: A string that identifies the type of event and the unique identifier of the CookieJar contract and the cookie.
- content: A string that contains the assessment of the reason for the claim.
