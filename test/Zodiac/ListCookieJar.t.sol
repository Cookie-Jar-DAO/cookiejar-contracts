// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { TestAvatar } from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";

import { ZodiacCloneSummoner, ZodiacListCookieJarHarnass } from "test/utils/ZodiacCloneSummoner.sol";
import { Test, Vm } from "forge-std/Test.sol";

contract ListCookieJarTest is ZodiacCloneSummoner {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);
    address internal testSafe = vm.addr(1337);

    ZodiacListCookieJarHarnass internal cookieJar;
    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    uint256 internal cookieAmount = 2e6;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(bytes32 indexed cookieUid, address indexed cookieMonster, uint256 amount, string reason);
    event AssessReason(bytes32 indexed cookieUid, string message, bool isGood);

    function setUp() public virtual {
        address[] memory allowList = new address[](2);
        allowList[0] = alice;
        allowList[1] = bob;

        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        // address[] _allowList,
        bytes memory initParams = abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken), allowList);

        cookieJar = getListCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));
    }

    function testIsAllowed() external {
        assertFalse(cookieJar.exposed_isAllowList(msg.sender));

        assertTrue(cookieJar.exposed_isAllowList(alice));
    }

    function testReachInJar() external {
        // Anon puts their hand in the jar
        vm.expectRevert(bytes("not a member"));
        cookieJar.reachInJar(reason);

        // Alice puts her hand in the jar
        vm.startPrank(alice);

        // No cookie balance so expect fail
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar
        cookieToken.mint(address(testAvatar), cookieAmount);

        vm.expectEmit(true, false, false, true);
        // GiveCookie is not the last emitted event so we drill down the logs
        // vm.expectEmit(false, false, false, true);
        // emit GiveCookie(alice, cookieAmount, CookieUtils.getCookieJarUid(address(cookieJar)));
        cookieJar.reachInJar(reason);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[3].topics[0], keccak256("GiveCookie(bytes32,address,uint256,string)"));
    }
}
