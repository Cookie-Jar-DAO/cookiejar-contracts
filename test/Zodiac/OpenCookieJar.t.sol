// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";

import {ZodiacCloneSummoner, ZodiacOpenCookieJarHarnass} from "test/utils/ZodiacCloneSummoner.sol";

contract OpenCookieJarTest is ZodiacCloneSummoner {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);

    ZodiacOpenCookieJarHarnass internal cookieJar;
    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    uint256 internal cookieAmount = 2e6;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(address indexed cookieMonster, uint256 amount, uint256 fee);

    function setUp() public virtual {
        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        bytes memory initParams = abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken));

        cookieJar = getOpenCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIsAllowList() external {
        //Always true for OpenCookieJar
        assertTrue(cookieJar.exposed_isAllowList(msg.sender));
    }

    function testReachInJar() external {
        // No cookie balance so expect fail
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar
        cookieToken.mint(address(testAvatar), cookieAmount);

        // Anon puts their hand in the jar
        vm.startPrank(alice);
        vm.expectEmit(false, false, false, true);
        emit GiveCookie(alice, cookieAmount, cookieAmount / 100);
        cookieJar.reachInJar(reason);
    }
}
