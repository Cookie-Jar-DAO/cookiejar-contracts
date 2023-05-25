// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Test, Vm} from "forge-std/Test.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {BaalCookieJarHarnass} from "test/BaalCookieJar.t.sol";
import {ZodiacERC20CookieJar} from "src/SafeModule/ERC20CookieJar.sol";
import {ZodiacERC721CookieJar} from "src/SafeModule/ERC721CookieJar.sol";
import {ZodiacListCookieJar} from "src/SafeModule/ListCookieJar.sol";
import {ZodiacOpenCookieJar} from "src/SafeModule/OpenCookieJar.sol";

contract ERC20CookieJarHarnass is ZodiacERC20CookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ERC721CookieJarHarnass is ZodiacERC721CookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ListCookieJarHarnass is ZodiacListCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract OpenCookieJarHarnass is ZodiacOpenCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract CloneSummoner is Test {
    CookieJarFactory public cookieJarFactory = new CookieJarFactory();
    BaalCookieJarHarnass internal baalCookieJarImplementation = new BaalCookieJarHarnass();
    ERC20CookieJarHarnass internal erc20CookieJarImplementation = new ERC20CookieJarHarnass();
    ERC721CookieJarHarnass internal erc721CookieJarImplementation = new ERC721CookieJarHarnass();
    ListCookieJarHarnass internal listCookieJarImplementation = new ListCookieJarHarnass();
    OpenCookieJarHarnass internal openCookieJarImplementation = new OpenCookieJarHarnass();

    event SummonCookieJar(address cookieJar, string _cookieType, bytes initParams);

    function getBaalCookieJar(bytes memory initParams) public returns (BaalCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar("Baal", address(baalCookieJarImplementation), initParams);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);
        assertEq(entries[2].topics[0], keccak256("SummonCookieJar(address,string,bytes)"));
        return BaalCookieJarHarnass(abi.decode(entries[2].data, (address)));
    }

    function getERC20CookieJar(bytes memory initParams) public returns (ERC20CookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar("ERC20", address(erc20CookieJarImplementation), initParams);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);
        assertEq(entries[2].topics[0], keccak256("SummonCookieJar(address,string,bytes)"));
        return ERC20CookieJarHarnass(abi.decode(entries[2].data, (address)));
    }

    function getERC721CookieJar(bytes memory initParams) public returns (ERC721CookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar("ERC721", address(erc721CookieJarImplementation), initParams);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);
        assertEq(entries[2].topics[0], keccak256("SummonCookieJar(address,string,bytes)"));
        return ERC721CookieJarHarnass(abi.decode(entries[2].data, (address)));
    }

    function getListCookieJar(bytes memory initParams) public returns (ListCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar("List", address(listCookieJarImplementation), initParams);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);
        assertEq(entries[2].topics[0], keccak256("SummonCookieJar(address,string,bytes)"));
        return ListCookieJarHarnass(abi.decode(entries[2].data, (address)));
    }

    function getOpenCookieJar(bytes memory initParams) public returns (OpenCookieJarHarnass) {
        vm.recordLogs();
        cookieJarFactory.summonCookieJar("Open", address(openCookieJarImplementation), initParams);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 3);
        assertEq(entries[2].topics[0], keccak256("SummonCookieJar(address,string,bytes)"));
        return OpenCookieJarHarnass(abi.decode(entries[2].data, (address)));
    }
}
