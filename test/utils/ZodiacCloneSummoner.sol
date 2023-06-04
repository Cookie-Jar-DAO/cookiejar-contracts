// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {Test, Vm} from "forge-std/Test.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";
import {ZodiacERC20CookieJar} from "src/SafeModule/ERC20CookieJar.sol";
import {ZodiacERC721CookieJar} from "src/SafeModule/ERC721CookieJar.sol";
import {ZodiacListCookieJar} from "src/SafeModule/ListCookieJar.sol";
import {ZodiacOpenCookieJar} from "src/SafeModule/OpenCookieJar.sol";
import {ZodiacBaalCookieJar} from "src/SafeModule/BaalCookieJar.sol";
import {ModuleProxyFactory} from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";

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
    ModuleProxyFactory public moduleProxyFactory = new ModuleProxyFactory();

    ZodiacBaalCookieJarHarnass internal baalCookieJarImplementation = new ZodiacBaalCookieJarHarnass();
    ZodiacERC20CookieJarHarnass internal erc20CookieJarImplementation = new ZodiacERC20CookieJarHarnass();
    ZodiacERC721CookieJarHarnass internal erc721CookieJarImplementation = new ZodiacERC721CookieJarHarnass();
    ZodiacListCookieJarHarnass internal listCookieJarImplementation = new ZodiacListCookieJarHarnass();
    ZodiacOpenCookieJarHarnass internal openCookieJarImplementation = new ZodiacOpenCookieJarHarnass();

    event SummonCookieJar(address cookieJar, string _cookieType, bytes initParams);

    uint256 internal saltNonce = 420;

    constructor() {
        cookieJarFactory.setProxyFactory(address(moduleProxyFactory));
    }

    function getBaalCookieJar(bytes memory initParams) public returns (ZodiacBaalCookieJarHarnass) {
        vm.recordLogs();

        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", initParams);

        cookieJarFactory.summonCookieJar(address(baalCookieJarImplementation), _initializer, "Baal", saltNonce);

        Vm.Log[] memory entries = vm.getRecordedLogs();

        assertEq(entries.length, 8);
        assertEq(entries[7].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        address cookieJar = _calculateCreate2Address(address(baalCookieJarImplementation), _initializer, saltNonce);

        assertEq(abi.decode(entries[7].data, (address)), cookieJar);

        return ZodiacBaalCookieJarHarnass(cookieJar);
    }

    function getERC20CookieJar(bytes memory initParams) public returns (ZodiacERC20CookieJarHarnass) {
        vm.recordLogs();
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", initParams);

        cookieJarFactory.summonCookieJar(address(erc20CookieJarImplementation), _initializer, "ERC20", saltNonce);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 8);
        assertEq(entries[7].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        address cookieJar = _calculateCreate2Address(address(erc20CookieJarImplementation), _initializer, saltNonce);

        assertEq(abi.decode(entries[7].data, (address)), cookieJar);
        return ZodiacERC20CookieJarHarnass(cookieJar);
    }

    function getERC721CookieJar(bytes memory initParams) public returns (ZodiacERC721CookieJarHarnass) {
        vm.recordLogs();

        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", initParams);

        cookieJarFactory.summonCookieJar(address(erc721CookieJarImplementation), _initializer, "ERC721", saltNonce);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 8);
        assertEq(entries[7].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        address cookieJar = _calculateCreate2Address(address(erc721CookieJarImplementation), _initializer, saltNonce);

        assertEq(abi.decode(entries[7].data, (address)), cookieJar);
        return ZodiacERC721CookieJarHarnass(cookieJar);
    }

    function getListCookieJar(bytes memory initParams) public returns (ZodiacListCookieJarHarnass) {
        vm.recordLogs();
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", initParams);

        cookieJarFactory.summonCookieJar(address(listCookieJarImplementation), _initializer, "List", saltNonce);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 8);
        assertEq(entries[7].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        address cookieJar = _calculateCreate2Address(address(listCookieJarImplementation), _initializer, saltNonce);

        assertEq(abi.decode(entries[7].data, (address)), cookieJar);
        return ZodiacListCookieJarHarnass(cookieJar);
    }

    function getOpenCookieJar(bytes memory initParams) public returns (ZodiacOpenCookieJarHarnass) {
        vm.recordLogs();
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", initParams);

        cookieJarFactory.summonCookieJar(address(openCookieJarImplementation), _initializer, "Open", saltNonce);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries.length, 8);
        assertEq(entries[7].topics[0], keccak256("SummonCookieJar(address,bytes,string)"));
        address cookieJar = _calculateCreate2Address(address(openCookieJarImplementation), _initializer, saltNonce);

        assertEq(abi.decode(entries[7].data, (address)), cookieJar);
        return ZodiacOpenCookieJarHarnass(cookieJar);
    }

    function _calculateCreate2Address(address template, bytes memory _initializer, uint256 _saltNonce)
        internal
        view
        returns (address cookieJar)
    {
        bytes32 salt = keccak256(abi.encodePacked(keccak256(_initializer), _saltNonce));

        // This is how ModuleProxyFactory works
        bytes memory deployment =
        //solhint-disable-next-line max-line-length
         abi.encodePacked(hex"602d8060093d393df3363d3d373d3d3d363d73", template, hex"5af43d82803e903d91602b57fd5bf3");

        bytes32 hash =
            keccak256(abi.encodePacked(bytes1(0xff), address(moduleProxyFactory), salt, keccak256(deployment)));

        // NOTE: cast last 20 bytes of hash to address
        cookieJar = address(uint160(uint256(hash)));
    }
}
