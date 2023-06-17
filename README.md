# CookieJar

CookieJar is a collection of smart contracts that allow users to deposit ERC20 and ERC721 tokens and earn interest on their deposits. The contracts are designed to be modular and extensible, allowing developers to easily add new features and functionality.

# Deployment

The following table lists the addresses of the deployed contracts:

## Gnosis

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0x7CEfc2492Cf3BEb03e5B8eF9ba52c4a219301425` |
| ERC20 Cookie Jar    | `0xF8Ff08a263D258c0618394734feD493806bd60cd` |
| ERC721 Cookie Jar   | `0x4ef92B5bE63605A0c27433F5AF88746384c379e5` |
| List Cookie Jar     | `0xcFb18dd95A3B8DBe27A25F0456f31508BBF0992A` |
| Open Cookie Jar     | `0x680982C79bE794Bcc4CDd52cDb547d73d8b1C6e9` |
| Cookie Jar Factory  | `0x998b53d1A35c9630eE655B8D4ec9D4488ed7678F` |
| List Cookie Jar6551 | `0xcFb18dd95A3B8DBe27A25F0456f31508BBF0992A` |
| Account             | `0x83006b5c56F909A97256a5678Fcc54E2b444528d` |
| Cookie Jar NFT      | `0xdc383fEB53B439ECE111625F67b28456db2899c6` |

## Goerli

| Contract            | Address                                      |
| ------------------- | -------------------------------------------- |
| Baal Cookie Jar     | `0x16369aF30e491981B773c8169abBBA9df4B16d52` |
| ERC20 Cookie Jar    | `0x9fF779Db6512BdeD0b3b93EA0BEfDc4b104a64B5` |
| ERC721 Cookie Jar   | `0x320991a135fd31Cb9CCFd8f6eefd46B33067E421` |
| List Cookie Jar     | `0x59b6A8f6515A42d1EB6711bD58f76D3c74617B52` |
| Open Cookie Jar     | `0x3865541C43178EfBAbd13ADB337a37392351C252` |
| Cookie Jar Factory  | `0xf348F2E75801da94282cf7700C316D68AeF3c787` |
| List Cookie Jar6551 | `0x59b6A8f6515A42d1EB6711bD58f76D3c74617B52` |
| Account             | `0xbF9C87e3871Cc79273f54dC2A2D7E772fECcA875` |
| Cookie Jar NFT      | `0x65022ba0cd19699d84a32945c710519c82b6597b` |

## 6551 Tokenbound Registry

The Tokenbound Registry for 6551 tokens is deployed on the following chains:

| Chain               | Address                                      |
| ------------------- | -------------------------------------------- |
| Arbitrum            | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Gnosis              | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |
| Optimism            | `0x02101dfB77FDE026414827Fdc604ddAF224F0921` |

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
