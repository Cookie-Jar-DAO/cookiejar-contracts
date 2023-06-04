// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {PRBTest} from "@prb/test/PRBTest.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ZodiacCookieJar} from "src/SafeModule/ZodiacCookieJar.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {CookieUtils} from "src/lib/CookieUtils.sol";

contract CookieJarHarnass is ZodiacCookieJar {
    function posterTag() public pure returns (string memory) {
        return POSTER_TAG;
    }

    function posterUid() public view returns (string memory) {
        return POSTER_UID;
    }

    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract ZodiacCookieJarTest is PRBTest, StdCheats {
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

        cookieJar = new CookieJarHarnass();
        cookieJar.setUp(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIsEnabledModule() external {
        assertEq(address(testAvatar), cookieJar.avatar());
        assertEq(address(testAvatar), cookieJar.target());
        assertTrue(testAvatar.isModuleEnabled(address(cookieJar)));
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

        // No balance so expect fail
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        assertTrue(cookieJar.canClaim(alice));
    }

    function testAssessReason() external {
        vm.startPrank(alice);
        string memory cookieUid = CookieUtils.getCookieUid(cookieJar.posterUid());

        string memory assessTag =
            string.concat(cookieJar.posterTag(), ".", cookieJar.posterUid(), ".reaction.", cookieUid);

        string memory senderString = Strings.toHexString(uint256(uint160(alice)), 20);

        vm.expectCall(
            0x000000000000cd17345801aa8147b8D3950260FF,
            abi.encodeCall(IPoster.post, (string.concat("UP ", senderString), assessTag))
        );
        cookieJar.assessReason(cookieUid, true);

        vm.expectCall(
            0x000000000000cd17345801aa8147b8D3950260FF,
            abi.encodeCall(IPoster.post, (string.concat("DOWN ", senderString), assessTag))
        );
        cookieJar.assessReason(cookieUid, false);
    }

    function testGiveAwayCookie() external {
        vm.startPrank(alice);
        assertTrue(cookieJar.canClaim(alice));

        // No balance so expect fail
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(bob, reason);

        assertTrue(cookieJar.canClaim(alice));
    }
}
