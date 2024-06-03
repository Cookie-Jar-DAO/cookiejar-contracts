// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { ZodiacCloneSummoner, ZodiacHatsCookieJar } from "test/utils/ZodiacCloneSummoner.sol";
import { MockHats } from "test/utils/MockHats.sol";
import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { TestAvatar } from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import { ERC20 } from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import { Test, Vm } from "forge-std/Test.sol";

contract HatsCookieJarTest is ZodiacCloneSummoner {
    ZodiacHatsCookieJar internal cookieJar;

    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");

    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    MockHats internal mockHats = new MockHats();

    uint256 internal cookieAmount = 2e6;
    uint256 internal threshold = 420;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(bytes32 indexed cookieUid, address indexed cookieMonster, uint256 amount, string reason);
    event AssessReason(bytes32 indexed cookieUid, string message, bool isGood);

    function setUp() public virtual {
        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        // address _hatsAddress,
        // uint256 _threshold,
        bytes memory initParams =
            abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken), address(mockHats), threshold);

        cookieJar = getHatsCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));
    }

    function testIsAllowed() external {
        mockHats.setMockResponse(false);

        assertFalse(cookieJar.isAllowList(msg.sender));

        mockHats.setMockResponse(true);
        assertTrue(cookieJar.isAllowList(msg.sender));
    }

    function testReachInJar() external {
        // No hat for user so expect fail
        mockHats.setMockResponse(false);

        vm.expectRevert(bytes("not a member"));
        cookieJar.reachInJar(reason);

        // No cookie balance so expect fail
        mockHats.setMockResponse(true);
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar
        cookieToken.mint(address(testAvatar), cookieAmount);

        // Alice puts her hand in the jar
        vm.startPrank(alice);
        // GiveCookie is not the last emitted event so we drill down the logs
        // vm.expectEmit(false, false, false, true);
        // emit GiveCookie(alice, cookieAmount, CookieUtils.getCookieJarUid(address(cookieJar)));
        cookieJar.reachInJar(reason);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[3].topics[0], keccak256("GiveCookie(bytes32,address,uint256,string)"));
    }
}
