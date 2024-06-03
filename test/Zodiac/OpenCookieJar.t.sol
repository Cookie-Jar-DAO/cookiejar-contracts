// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { TestAvatar } from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";

import { ZodiacCloneSummoner, ZodiacOpenCookieJar } from "test/utils/ZodiacCloneSummoner.sol";
import { Test, Vm } from "forge-std/Test.sol";

contract OpenCookieJarTest is ZodiacCloneSummoner {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);

    ZodiacOpenCookieJar internal cookieJar;
    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    uint256 internal cookieAmount = 2e6;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(bytes32 indexed cookieUid, address indexed cookieMonster, uint256 amount, string reason);
    event AssessReason(bytes32 indexed cookieUid, string message, bool isGood);

    function setUp() public virtual {
        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        bytes memory initParams = abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken));

        cookieJar = getOpenCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));
    }

    function testIsAllowList() external {
        //Always true for OpenCookieJar
        assertTrue(cookieJar.isAllowList(msg.sender));
    }

    function testReachInJar() external {
        // No cookie balance so expect fail
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar
        cookieToken.mint(address(testAvatar), cookieAmount);

        // Anon puts their hand in the jar
        vm.startPrank(alice);
        // GiveCookie is not the last emitted event so we drill down the logs
        cookieJar.reachInJar(reason);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[3].topics[0], keccak256("GiveCookie(bytes32,address,uint256,string)"));
    }
}
