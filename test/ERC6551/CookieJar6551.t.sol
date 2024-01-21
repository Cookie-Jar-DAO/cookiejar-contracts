// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";
import { IPoster } from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { CookieUtils } from "src/lib/CookieUtils.sol";
import { CookieJar6551 } from "src/ERC6551/CookieJar6551.sol";

contract CookieJarHarnass is CookieJar6551 {
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

contract CookieJar6551Test is PRBTest, StdCheats {
    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");

    CookieJarHarnass internal cookieJar;
    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");

    uint256 internal cookieAmount = 2e6;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(address indexed cookieMonster, uint256 amount);
    event NewPost(address indexed user, string content, string indexed tag);

    function setUp() public virtual {
        // address _owner,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken
        bytes memory initParams = abi.encode(alice, 3600, cookieAmount, address(cookieToken));

        cookieJar = new CookieJarHarnass();
        cookieJar.setUp(initParams);

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

        // No balance so expect fail
        vm.expectRevert();
        cookieJar.reachInJar(reason);

        assertTrue(cookieJar.canClaim(alice));
        vm.stopPrank();
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
        vm.stopPrank();
    }

    function testGiveAwayCookie() external {
        vm.startPrank(alice);
        assertTrue(cookieJar.canClaim(alice));

        // No balance so expect fail
        vm.expectRevert();
        cookieJar.reachInJar(bob, reason);

        assertTrue(cookieJar.canClaim(alice));
        vm.stopPrank();
    }
}
