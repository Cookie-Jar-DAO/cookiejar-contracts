// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { CookieJarCore } from "src/core/CookieJarCore.sol";
import { TestAvatar } from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { ICookieJar } from "src/interfaces/ICookieJar.sol";

contract MockCookieJarCore is CookieJarCore {
    function __Giver_init(bytes memory _initializationParams) public override { }

    function __Allowlist_init(bytes memory _initializationParams) public override { }

    function isAllowlist(address user) public view returns (bool) {
        return _isAllowList(user);
    }

    function reachInJar(string calldata reason) public override {
        // Do nothing
    }

    function _isAllowList(address user) internal view override returns (bool) {
        return true;
    }

    function _giveCookie(
        address cookieMonster,
        uint256 amount,
        address cookieToken
    )
        internal
        override
        returns (bytes32 cookieUid)
    {
        cookieUid = keccak256("cookieUid");
    }
}

contract CookieJarCoreTest is PRBTest, StdCheats {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);

    MockCookieJarCore internal cookieJar;
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
        // address _cookieToken
        bytes memory initParams = abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken));

        cookieJar = new MockCookieJarCore();
        cookieJar.setUp(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));
    }

    function testIsAllowList() external {
        assertTrue(cookieJar.isAllowList(msg.sender));
    }

    function testCanClaim() external {
        assertTrue(cookieJar.canClaim(msg.sender));
    }

    function testReachInJar() external {
        // Base implementation only limits periods
        vm.startPrank(alice);
        assertTrue(cookieJar.canClaim(alice));
        cookieJar.reachInJar(reason);
        assertFalse(cookieJar.canClaim(alice));
    }

    function testAssessReason() external {
        vm.startPrank(alice);
        bytes32 cookieUid = CookieUtils.getCookieUid();

        string memory message = "testing 1234";
        string memory senderString = Strings.toHexString(uint256(uint160(alice)), 20);

        vm.expectEmit(true, true, false, true);
        emit AssessReason(cookieUid, message, true);

        cookieJar.assessReason(cookieUid, message, true);

        vm.expectEmit(true, true, false, true);
        emit AssessReason(cookieUid, message, false);

        cookieJar.assessReason(cookieUid, message, false);
    }

    function testGiveAwayCookie() external {
        vm.startPrank(alice);
        assertTrue(cookieJar.canClaim(alice));
        cookieJar.reachInJar(reason);
        assertFalse(cookieJar.canClaim(alice));
    }
}
