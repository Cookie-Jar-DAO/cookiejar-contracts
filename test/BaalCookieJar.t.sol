// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <0.9.0;

import {IBaal} from "@daohaus/baal-contracts/contracts/interfaces/IBaal.sol";
import {IBaalToken} from "@daohaus/baal-contracts/contracts/interfaces/IBaalToken.sol";
import {ZodiacBaalCookieJar} from "src/SafeModule/BaalCookieJar.sol";
import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Mintable} from "test/utils/ERC20Mintable.sol";
import {TestAvatar} from "@gnosis.pm/zodiac/contracts/test/TestAvatar.sol";
import {IPoster} from "@daohaus/baal-contracts/contracts/interfaces/IPoster.sol";
import {CookieJarFactory} from "src/factory/CookieJarFactory.sol";

import {CloneSummoner} from "test/utils/CloneSummoner.sol";

contract BaalCookieJarHarnass is ZodiacBaalCookieJar {
    function exposed_isAllowList(address user) external view returns (bool) {
        return isAllowList(user);
    }
}

contract BaalCookieJarTest is CloneSummoner {
    BaalCookieJarHarnass internal cookieJar;

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
    event GiveCookie(address indexed cookieMonster, uint256 amount, uint256 fee);

    function setUp() public virtual {
        vm.mockCall(molochDAO, abi.encodeWithSelector(IBaal.sharesToken.selector), abi.encode(sharesToken));
        vm.mockCall(molochDAO, abi.encodeWithSelector(IBaal.target.selector), abi.encode(sharesToken));

        // address _safeTarget,
        // uint256 _periodLength,
        // uint256 _cookieAmount,
        // address _cookieToken,
        // address _dao,
        // uint256 _threshold,
        // bool _useShares,
        // bool _useLoot
        bytes memory initParams =
            abi.encode(address(testAvatar), 3600, cookieAmount, address(cookieToken), molochDAO, 1, true, true);

        cookieJar = getBaalCookieJar(initParams);

        // Enable module
        testAvatar.enableModule(address(cookieJar));

        vm.mockCall(0x000000000000cd17345801aa8147b8D3950260FF, abi.encodeWithSelector(IPoster.post.selector), "");
    }

    function testIdentifyMolochMember() external {
        vm.expectRevert();
        cookieJar.exposed_isAllowList(msg.sender);

        vm.mockCall(address(sharesToken), abi.encodeWithSelector(IBaalToken.balanceOf.selector), abi.encode(1));
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
        emit GiveCookie(alice, cookieAmount, cookieAmount / 100);
        cookieJar.reachInJar(reason);
    }
}
