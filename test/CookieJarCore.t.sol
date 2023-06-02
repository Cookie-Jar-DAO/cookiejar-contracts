// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {CookieJarCore} from "src/core/CookieJarCore.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

contract CookieJarHarnass is CookieJarCore {
    constructor(bytes memory initParams) {
        setUp(initParams);
    }

    function setUp(bytes memory initParams) public override initializer {
        super.setUp(initParams);
    }

    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract CookieJarCoreTest is PRBTest, StdCheats {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);

    CookieJarHarnass internal cookieJar;
    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    uint256 internal cookieAmount = 2e6;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(address indexed cookieMonster, uint256 amount);
    event NewPost(address indexed user, string content, string indexed tag);

    function setUp() public virtual {
        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken
        bytes memory initParams = abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken));

        cookieJar = new CookieJarHarnass(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIsAllowList() external {
        assertTrue(cookieJar.exposed_isAllowList(msg.sender));
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
        string memory uid = "testEmit";
        string memory senderString = Strings.toHexString(uint256(uint160(alice)), 20);
        string memory tag = string.concat("CookieJar", ".reaction");

        vm.expectCall(
            0x000000000000cd17345801aa8147b8D3950260FF,
            abi.encodeCall(IPoster.post, (string.concat(uid, " UP ", senderString), tag))
        );
        cookieJar.assessReason(uid, true);

        vm.expectCall(
            0x000000000000cd17345801aa8147b8D3950260FF,
            abi.encodeCall(IPoster.post, (string.concat(uid, " DOWN ", senderString), tag))
        );
        cookieJar.assessReason(uid, false);
    }

    function testGiveAwayCookie() external {
        vm.startPrank(alice);
        assertTrue(cookieJar.canClaim(alice));
        cookieJar.reachInJar(reason);
        assertFalse(cookieJar.canClaim(alice));
    }
}
