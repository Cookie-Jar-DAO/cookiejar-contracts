// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {IBaal} from "@daohaus/baal-contracts/contracts/interfaces/IBaal.sol";
import {IBaalToken} from "@daohaus/baal-contracts/contracts/interfaces/IBaalToken.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";

import {ZodiacCloneSummoner, ZodiacBaalCookieJarHarnass} from "test/utils/ZodiacCloneSummoner.sol";

contract BaalCookieJarTest is ZodiacCloneSummoner {
    ZodiacBaalCookieJarHarnass internal cookieJar;

    address internal alice = makeAddr("alice");
    address internal bob = makeAddr("bob");
    address internal molochDAO = vm.addr(666);

    ERC20Mintable internal cookieToken = new ERC20Mintable("Mock", "MCK");
    TestAvatar internal testAvatar = new TestAvatar();

    ERC20 internal sharesToken = new ERC20("Share", "SHR");
    ERC20 internal lootToken = new ERC20("Loot", "LOOT");

    uint256 internal cookieAmount = 2e6;

    string internal reason = "BaalCookieJar: Testing";

    event Setup(bytes initializationParams);
    event GiveCookie(address indexed cookieMonster, uint256 amount);

    function setUp() public virtual {
        vm.mockCall(molochDAO, abi.encodeWithSelector(IBaal.sharesToken.selector), abi.encode(sharesToken));
        vm.mockCall(molochDAO, abi.encodeWithSelector(IBaal.lootToken.selector), abi.encode(lootToken));
        vm.mockCall(molochDAO, abi.encodeWithSelector(IBaal.target.selector), abi.encode(sharesToken));

        bytes memory initParams =
            abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken), molochDAO, 1, true, true);

        cookieJar = getBaalCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIdentifyMolochMember() external {
        assertFalse(cookieJar.exposed_isAllowList(msg.sender));

        vm.mockCall(address(sharesToken), abi.encodeWithSelector(IBaalToken.balanceOf.selector), abi.encode(1));
        vm.mockCall(address(lootToken), abi.encodeWithSelector(IBaalToken.balanceOf.selector), abi.encode(1));

        assertTrue(cookieJar.exposed_isAllowList(msg.sender));
    }

    function testReachInJar() external {
        // No balance so expect fail
        vm.mockCall(address(sharesToken), abi.encodeWithSelector(IBaalToken.balanceOf.selector), abi.encode(1));

        vm.expectRevert(bytes("call failure setup"));
        cookieJar.reachInJar(reason);

        // Put cookie tokens in jar

        cookieToken.mint(address(testAvatar), cookieAmount);

        // Alice puts her hand in the jar
        vm.startPrank(alice);
        vm.expectEmit(false, false, false, true);
        emit GiveCookie(alice, cookieAmount);
        cookieJar.reachInJar(reason);
    }
}
