// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {CloneSummoner, ERC20CookieJarHarnass} from "test/utils/CloneSummoner.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract ERC20CookieJarTest is CloneSummoner {
    ERC20CookieJarHarnass internal cookieJar;

    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");

    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    ERC20 internal gatingERC20 = new ERC20("Gating", "GATE");

    uint256 internal cookieAmount = 2e6;
    uint256 internal threshold = 420;

    string internal reason = "CookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(address indexed cookieMonster, uint256 amount, uint256 fee);

    function setUp() public virtual {
        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        // address _erc20addr,
        // uint256 _threshold,
        bytes memory initParams =
            abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken), address(gatingERC20), threshold);

        cookieJar = getERC20CookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIsAllowed() external {
        assertFalse(cookieJar.exposed_isAllowList(msg.sender));

        vm.mockCall(address(gatingERC20), abi.encodeWithSelector(ERC20.balanceOf.selector), abi.encode(threshold));
        assertTrue(cookieJar.exposed_isAllowList(msg.sender));
    }

    function testReachInJar() external {
        // No gating token balance so expect fail
        vm.expectRevert(bytes("not a member"));
        cookieJar.reachInJar(reason);

        // No cookie balance so expect fail
        vm.mockCall(address(gatingERC20), abi.encodeWithSelector(ERC20.balanceOf.selector), abi.encode(threshold));
        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar
        cookieToken.mint(address(testAvatar), cookieAmount);

        // Alice puts her hand in the jar
        vm.startPrank(alice);
        vm.expectEmit(false, false, false, true);
        emit GiveCookie(alice, cookieAmount, cookieAmount / 100);
        cookieJar.reachInJar(reason);
    }
}
