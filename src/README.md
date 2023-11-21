# CookieJar

CookieJar is a collection of smart contracts that allow users to deposit ERC20 and ERC721 tokens and earn interest on their deposits. The contracts are designed to be modular and extensible, allowing developers to easily add new features and functionality.

# Deployment

The following table lists the addresses of the deployed contracts:

## Gnosis

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0x0a0DF97bDdb36eeF95fef089A4aEb7acEaBF2101` |
| ERC20 Cookie Jar    | `0xa16DFb32Eb140a6f3F2AC68f41dAd8c7e83C4941` |
| ERC721 Cookie Jar   | `0xC2d179166bc9dbB00A03686a5b17eCe2224c2704` |
| List Cookie Jar     | `0xc756B203cA9e13BAB3a93F1dA756bb19ac3C395b` |
| Open Cookie Jar     | `0x034f8eB38F0AC305B5baEC6266FFDBCEfa67fBD8` |
| Cookie Jar Factory  | `0xc695a9f30131C3566f5E7A577Cf39Ad7F305eD55` |
| List Cookie Jar6551 | `0xc756B203cA9e13BAB3a93F1dA756bb19ac3C395b` |
| Account             | `0x7AFc7938130bd03b792C0B05C796f42E9beBB2D6` |
| Cookie Jar NFT      | `0x75358Ae0192c002AEb9C397B626b21A5b0dE1409` |

## Goerli

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0xa16DFb32Eb140a6f3F2AC68f41dAd8c7e83C4941` |
| ERC20 Cookie Jar    | `0xC2d179166bc9dbB00A03686a5b17eCe2224c2704` |
| ERC721 Cookie Jar   | `0xc756B203cA9e13BAB3a93F1dA756bb19ac3C395b` |
| List Cookie Jar     | `0x034f8eB38F0AC305B5baEC6266FFDBCEfa67fBD8` |
| Open Cookie Jar     | `0xc695a9f30131C3566f5E7A577Cf39Ad7F305eD55` |
| Cookie Jar Factory  | `0xfB1eD3Fe2978c8aCf1cBA19145D7349A4730EfAd` |
| List Cookie Jar6551 | `0x034f8eB38F0AC305B5baEC6266FFDBCEfa67fBD8` |
| Account             | `0x75358Ae0192c002AEb9C397B626b21A5b0dE1409` |
| Cookie Jar NFT      | `0x3Ebf845AfaFf2475788cF2E3ea636De76D6BEeA8` |

## Mainnet

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| ERC20 Cookie Jar    | `0x0000000000000000000000000000000000000000` |
| ERC721 Cookie Jar   | `0x0000000000000000000000000000000000000000` |
| List Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| Open Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| Cookie Jar Factory  | `0x0000000000000000000000000000000000000000` |
| List Cookie Jar6551 | `0x0000000000000000000000000000000000000000` |
| Account             | `0x0000000000000000000000000000000000000000` |
| Cookie Jar NFT      | `0x0000000000000000000000000000000000000000` |

## Optimism

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| ERC20 Cookie Jar    | `0x0000000000000000000000000000000000000000` |
| ERC721 Cookie Jar   | `0x0000000000000000000000000000000000000000` |
| List Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| Open Cookie Jar     | `0x0000000000000000000000000000000000000000` |
| Cookie Jar Factory  | `0x0000000000000000000000000000000000000000` |
| List Cookie Jar6551 | `0x0000000000000000000000000000000000000000` |
| Account             | `0x0000000000000000000000000000000000000000` |
| Cookie Jar NFT      | `0x0000000000000000000000000000000000000000` |

## 6551 Tokenbound Registry

The Tokenbound Registry for 6551 tokens is deployed on the following chains:

| Chain    | Address                                      |
| -------- | -------------------------------------------- |
| Arbitrum | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Gnosis   | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Optimism | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |

## Sustainability Safe

To fund further development we implemented sustainability fees when claiming cookies and the option to donate native tokens or ERC20s when summoning a CookieJar. Donations are optional; summon the CookieJar with `donationToken` = address(0) and `donationAmount` = 0;

| Chain    | Address                                      |
| -------- | -------------------------------------------- |
| Gnosis   | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Mainnet  | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |
| Optimism | `0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc` |

## Installation

To run the CookieJar contracts, you will need to have foundry installed on your system. You can then run the following command:

`forge compile`

And you should get no errors

## Testing

To run the tests for the Cookie Jar contracts, you can run the following command:

`forge test`

## Jar features

### Cookie Jar Initialization Parameters

The Cookie Jar contract can be initialized with a set of parameters that define the behavior of the contract. The parameters are passed to the contract's constructor as an array of values.

The parameters are different depending on the type of Cookie Jar being created. There are three types of Cookie Jars: Baal, ERC20, and ERC721. The parameters for each type of Cookie Jar are as follows:

#### Baal Cookie Jar

| Parameter | Type    | Description                                                |
| --------- | ------- | ---------------------------------------------------------- |
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
| --------- | ------- | ---------------------------------------------------------- |
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | address | The address of the ERC20 token contract.                   |
| 5         | uint256 | The threshold for balance in the ERC20 token contract.     |

#### ERC721 Cookie Jar

| Parameter | Type    | Description                                                |
| --------- | ------- | ---------------------------------------------------------- |
| 0         | address | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256 | The length of the period for the Cookie Jar.               |
| 2         | uint256 | The amount of cookies to be distributed per period.        |
| 3         | address | The address of the cookie token contract.                  |
| 4         | address | The address of the ERC721 token contract.                  |
| 5         | uint256 | The threshold for balance in the ERC721 token contract.    |

#### Mapping Cookie Jar

| Parameter | Type      | Description                                                |
| --------- | --------- | ---------------------------------------------------------- |
| 0         | address   | The address of the owner or safe target of the Cookie Jar. |
| 1         | uint256   | The length of the period for the Cookie Jar.               |
| 2         | uint256   | The amount of cookies to be distributed per period.        |
| 3         | address   | The address of the cookie token contract.                  |
| 4         | address[] | The list of addresses allowed to claim cookies.            |

The parameters for each type of Cookie Jar are passed to the summonCookieJar function as a byte array. The byte array is constructed by encoding the parameters in the order listed above.

## Poster schema

The Poster contract is used to emit events on chain as a way to store more complex information on chain in a gas-efficient manner.

### Generating IDs

The CookieUtils library provides utility functions for generating unique identifiers (UIDs) for cookies and cookie jars.

#### getCookieJarUid

The getCookieJarUid function is used to generate a unique identifier for a cookie jar. The function takes an address parameter cookieJarAddr and returns a string that represents the unique identifier.

For example, to generate a unique identifier for a new cookie jar, you can call the getCookieJarUid function with the address of the new cookie jar as the input parameter:

```js
    function getCookieJarUid(address cookieJarAddr) internal view returns (string memory) {
        return string(abi.encodePacked(Strings.toHexString(uint160(cookieJarAddr)), Strings.toHexString(block.chainid)));
    }
```

The unique identifier is generated by concatenating the hexadecimal representation of the cookieJarAddr parameter with the hexadecimal representation of the current blockchain chain ID.

#### getCookieUid

The getCookieUid function is used to generate a unique identifier for a cookie. The function takes a string parameter cookieJarUid and returns a string that represents the unique identifier.

Similarly, to generate a unique identifier for a new cookie, you can call the getCookieUid function with the unique identifier of the cookie jar as the input parameter:

```js
   function getCookieUid(string memory cookieJarUid) internal view returns (string memory) {
        return bytes32ToString(keccak256(abi.encodePacked(cookieJarUid, msg.sender, block.timestamp)));
    }
```

The unique identifier is generated by concatenating the cookieJarUid parameter with the hexadecimal representation of the current user's address and the current block timestamp.

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

The assess reason event is used to store an assessment of a reason for a claim made by a user. The event has the following schema:

```json
{
  "tag": "CookieJar.<jar_uid>.reaction.<cookie_uid>",
  "content": "...reason...",
  "link": "app.daohaus.club/0x64/0x0....666"
}
```

- tag: A string that identifies the type of event and the unique identifier of the CookieJar contract and the cookie.
- content: A string that contains the assessment of the reason for the claim.
