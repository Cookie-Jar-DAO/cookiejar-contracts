// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Test, Vm} from "forge-std/Test.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {ZodiacERC20CookieJar} from "src/SafeModule/ERC20CookieJar.sol";
import {ZodiacERC721CookieJar} from "src/SafeModule/ERC721CookieJar.sol";
import {ZodiacListCookieJar} from "src/SafeModule/ListCookieJar.sol";
import {ZodiacOpenCookieJar} from "src/SafeModule/OpenCookieJar.sol";
import {ZodiacBaalCookieJar} from "src/SafeModule/BaalCookieJar.sol";

contract ZodiacBaalCookieJarHarnass is ZodiacBaalCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacERC20CookieJarHarnass is ZodiacERC20CookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacERC721CookieJarHarnass is ZodiacERC721CookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacListCookieJarHarnass is ZodiacListCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacOpenCookieJarHarnass is ZodiacOpenCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacCloneSummoner is Test {
    CookieJarFactory public cookieJarFactory = new CookieJarFactory();
    ZodiacBaalCookieJarHarnass internal baalCookieJarImplementation = new ZodiacBaalCookieJarHarnass();
    ZodiacERC20CookieJarHarnass internal erc20CookieJarImplementation = new ZodiacERC20CookieJarHarnass();
    ZodiacERC721CookieJarHarnass internal erc721CookieJarImplementation = new ZodiacERC721CookieJarHarnass();
    ZodiacListCookieJarHarnass internal listCookieJarImplementation = new ZodiacListCookieJarHarnass();
    ZodiacOpenCookieJarHarnass internal openCookieJarImplementation = new ZodiacOpenCookieJarHarnass();

    event SummonCookieJar(address cookieJar, string _cookieType, bytes initParams);

    function getBaalCookieJar(bytes memory initParams) public returns (ZodiacBaalCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar(address(baalCookieJarImplementation), initParams, "Baal");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 5);
        assertEq(entries[4].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        return ZodiacBaalCookieJarHarnass(abi.decode(entries[4].data, (address)));
    }

    function getERC20CookieJar(bytes memory initParams) public returns (ZodiacERC20CookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar(address(erc20CookieJarImplementation), initParams, "ERC20");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 5);
        assertEq(entries[4].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        return ZodiacERC20CookieJarHarnass(abi.decode(entries[4].data, (address)));
    }

    function getERC721CookieJar(bytes memory initParams) public returns (ZodiacERC721CookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar(address(erc721CookieJarImplementation), initParams, "ERC721");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 5);
        assertEq(entries[4].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        return ZodiacERC721CookieJarHarnass(abi.decode(entries[4].data, (address)));
    }

    function getListCookieJar(bytes memory initParams) public returns (ZodiacListCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar(address(listCookieJarImplementation), initParams, "List");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 5);
        assertEq(entries[4].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        return ZodiacListCookieJarHarnass(abi.decode(entries[4].data, (address)));
    }

    function getOpenCookieJar(bytes memory initParams) public returns (ZodiacOpenCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar(address(openCookieJarImplementation), initParams, "Open");

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 5);
        assertEq(entries[4].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        return ZodiacOpenCookieJarHarnass(abi.decode(entries[4].data, (address)));
    }
}
