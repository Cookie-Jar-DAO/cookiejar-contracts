// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {console2} from "forge-std/console2.sol";
import {StdCheats} from "forge-std/StdCheats.sol";

import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {ZodiacBaalCookieJar} from "src/SafeModule/BaalCookieJar.sol";
import {ZodiacERC20CookieJar} from "src/SafeModule/ERC20CookieJar.sol";
import {ZodiacERC721CookieJar} from "src/SafeModule/ERC721CookieJar.sol";
import {ZodiacListCookieJar} from "src/SafeModule/ListCookieJar.sol";
import {ZodiacOpenCookieJar} from "src/SafeModule/OpenCookieJar.sol";

contract SummonCookieJarTest is PRBTest, StdCheats {
    CookieJarFactory public cookieJarFactory = new CookieJarFactory();
    address internal _safeTarget = makeAddr("safe");
    address internal _mockERC20 = makeAddr("erc20");
    address internal _mockERC721 = makeAddr("erc721");
    uint256 internal _cookieAmount = 2e6;
    uint256 internal _periodLength = 3600;
    address internal _cookieToken = makeAddr("cookieToken");
    address internal _dao = makeAddr("dao");
    uint256 internal _threshold = 1;
    bool internal _useShares = true;
    bool internal _useLoot = true;

    event SummonCookieJar(address cookieJar, bytes initializer, string details);

    function testSummonBaalCookieJar() public {
        ZodiacBaalCookieJar baalCookieJar = new ZodiacBaalCookieJar();
        bytes memory _initializer =
            abi.encode("safe", _periodLength, _cookieAmount, "cookieToken", "dao", _threshold, _useShares, _useLoot);

        // Only check is event emits, not the values
        vm.expectEmit(false, false, false, false);
        emit SummonCookieJar(address(baalCookieJar), _initializer, "Baal");

        cookieJarFactory.summonCookieJar(address(baalCookieJar), _initializer, "Baal");
    }

    function testSummonERC20CookieJar() public {
        ZodiacERC20CookieJar erc20CookieJar = new ZodiacERC20CookieJar();
        /*solhint-disable max-line-length*/
        bytes memory _initializer = abi.encode("safe", _periodLength, _cookieAmount, "cookieToken", "erc20", _threshold);

        // Only check is event emits, not the values
        vm.expectEmit(false, false, false, false);
        emit SummonCookieJar(address(erc20CookieJar), _initializer, "ERC20");
        cookieJarFactory.summonCookieJar(address(erc20CookieJar), _initializer, "ERC20");
    }

    function testSummonERC721CookieJar() public {
        ZodiacERC721CookieJar erc721CookieJar = new ZodiacERC721CookieJar();
        bytes memory _initializer = abi.encode("safe", _periodLength, _cookieAmount, "cookieToken", "erc721");

        // Only check is event emits, not the values
        vm.expectEmit(false, false, false, false);
        emit SummonCookieJar(address(erc721CookieJar), _initializer, "ERC721");
        cookieJarFactory.summonCookieJar(address(erc721CookieJar), _initializer, "ERC721");
    }

    function testSummonListCookieJar() public {
        ZodiacListCookieJar listCookieJar = new ZodiacListCookieJar();
        address[] memory _list = new address[](2);

        _list[0] = makeAddr("alice");
        _list[1] = makeAddr("bob");
        bytes memory _initializer = abi.encode("safe", _periodLength, _cookieAmount, "cookieToken", _list);

        // Only check is event emits, not the values
        vm.expectEmit(false, false, false, false);
        emit SummonCookieJar(address(listCookieJar), _initializer, "List");
        cookieJarFactory.summonCookieJar(address(listCookieJar), _initializer, "List");
    }

    function testSummonOpenCookieJar() public {
        ZodiacOpenCookieJar openCookieJar = new ZodiacOpenCookieJar();
        bytes memory _initializer = abi.encode("safe", _periodLength, _cookieAmount, "cookieToken");

        // Only check is event emits, not the values
        vm.expectEmit(false, false, false, false);
        emit SummonCookieJar(address(openCookieJar), _initializer, "Open");
        cookieJarFactory.summonCookieJar(address(openCookieJar), _initializer, "Open");
    }
}
