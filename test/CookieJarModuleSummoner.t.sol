// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.19;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { ModuleProxyFactory } from "@gnosis.pm/zodiac/contracts/factory/ModuleProxyFactory.sol";
import { ERC20Mintable } from "test/utils/ERC20Mintable.sol";

import { CookieJarFactory } from "src/factory/CookieJarFactory.sol";
import { ZodiacBaalCookieJar } from "src/SafeModule/BaalCookieJar.sol";
import { ZodiacERC20CookieJar } from "src/SafeModule/ERC20CookieJar.sol";
import { ZodiacERC721CookieJar } from "src/SafeModule/ERC721CookieJar.sol";
import { ZodiacListCookieJar } from "src/SafeModule/ListCookieJar.sol";
import { ZodiacOpenCookieJar } from "src/SafeModule/OpenCookieJar.sol";
import { CookieJarFactory } from "src/factory/CookieJarFactory.sol";

contract CookieJarModuleSummonerTest is PRBTest, StdCheats {
    CookieJarFactory public cookieJarSummoner = new CookieJarFactory();
    ModuleProxyFactory public moduleProxyFactory = new ModuleProxyFactory();
    address internal _safeTarget = makeAddr("safe");
    address internal _mockERC20 = makeAddr("erc20");
    address internal _mockERC721 = makeAddr("erc721");
    uint256 internal _cookieAmount = 2e6;
    uint256 internal _periodLength = 3600;
    address internal _cookieToken = makeAddr("cookieToken");
    address internal _dao = makeAddr("dao");
    uint256 internal _threshold = 1;
    bool internal _useShares = true;
    bool internal _useLoot = true;

    event SummonCookieJar(address cookieJarSingleton, string jarType, bytes initializer, uint256 saltNonce);
    event DonationReceived(address donationToken, uint256 donationAmount);

    function setUp() public virtual {
        cookieJarSummoner.setProxyFactory(address(moduleProxyFactory));
    }

    function _calculateCreate2Address(
        address template,
        bytes memory _initializer,
        uint256 _saltNonce
    )
        internal
        view
        returns (address cookieJar)
    {
        bytes32 salt = keccak256(abi.encodePacked(keccak256(_initializer), _saltNonce));

        // This is how ModuleProxyFactory works
        bytes memory deployment =
        //solhint-disable-next-line max-line-length
         abi.encodePacked(hex"602d8060093d393df3363d3d373d3d3d363d73", template, hex"5af43d82803e903d91602b57fd5bf3");

        bytes32 hash =
            keccak256(abi.encodePacked(bytes1(0xff), address(moduleProxyFactory), salt, keccak256(deployment)));

        // NOTE: cast last 20 bytes of hash to address
        cookieJar = address(uint160(uint256(hash)));
    }

    function testSummonBaalCookieJar() public {
        ZodiacBaalCookieJar baalCookieJarSingleton = new ZodiacBaalCookieJar();

        bytes memory _initializerParams =
            abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken, _dao, _threshold, _useShares, _useLoot);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "BaalCookieJar";
        uint256 saltNonce = 1_234_567_890;

        cookieJarSummoner.summonCookieJar(
            address(baalCookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        address cookieJar = _calculateCreate2Address(address(baalCookieJarSingleton), _initializer, saltNonce);

        ZodiacBaalCookieJar baalCookieJar = ZodiacBaalCookieJar(cookieJar);

        assertEq(baalCookieJar.owner(), address(_safeTarget));
        assertEq(baalCookieJar.dao(), _dao);
        assertEq(baalCookieJar.threshold(), _threshold);
        assertEq(baalCookieJar.useShares(), _useShares);
        assertEq(baalCookieJar.useLoot(), _useLoot);
        assertEq(baalCookieJar.avatar(), _safeTarget);
        assertEq(baalCookieJar.target(), _safeTarget);
        assertEq(baalCookieJar.cookieAmount(), _cookieAmount);
        assertEq(baalCookieJar.cookieToken(), _cookieToken);
        assertEq(baalCookieJar.periodLength(), _periodLength);
    }

    function testSummonERC20CookieJar() public {
        ZodiacERC20CookieJar erc20CookieJarSingleton = new ZodiacERC20CookieJar();

        bytes memory _initializerParams =
            abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken, _mockERC20, _threshold);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "ERC20CookieJar";
        uint256 saltNonce = 1_234_567_890;

        cookieJarSummoner.summonCookieJar(
            address(erc20CookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        address cookieJar = _calculateCreate2Address(address(erc20CookieJarSingleton), _initializer, saltNonce);

        ZodiacERC20CookieJar erc20CookieJar = ZodiacERC20CookieJar(cookieJar);

        assertEq(erc20CookieJar.owner(), address(_safeTarget));
        assertEq(erc20CookieJar.erc20Addr(), _mockERC20);
        assertEq(erc20CookieJar.threshold(), _threshold);
        assertEq(erc20CookieJar.avatar(), _safeTarget);
        assertEq(erc20CookieJar.target(), _safeTarget);
        assertEq(erc20CookieJar.cookieAmount(), _cookieAmount);
        assertEq(erc20CookieJar.cookieToken(), _cookieToken);
        assertEq(erc20CookieJar.periodLength(), _periodLength);
    }

    function testSummonERC721CookieJar() public {
        ZodiacERC721CookieJar erc721CookieJarSingleton = new ZodiacERC721CookieJar();

        bytes memory _initializerParams =
            abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken, _mockERC721);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "ERC721CookieJar";
        uint256 saltNonce = 1_234_567_890;

        cookieJarSummoner.summonCookieJar(
            address(erc721CookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        address cookieJar = _calculateCreate2Address(address(erc721CookieJarSingleton), _initializer, saltNonce);

        ZodiacERC721CookieJar erc721CookieJar = ZodiacERC721CookieJar(cookieJar);

        assertEq(erc721CookieJar.owner(), address(_safeTarget));
        assertEq(erc721CookieJar.erc721Addr(), _mockERC721);
        assertEq(erc721CookieJar.avatar(), _safeTarget);
        assertEq(erc721CookieJar.target(), _safeTarget);
        assertEq(erc721CookieJar.cookieAmount(), _cookieAmount);
        assertEq(erc721CookieJar.cookieToken(), _cookieToken);
        assertEq(erc721CookieJar.periodLength(), _periodLength);
    }

    function testSummonListCookieJar() public {
        ZodiacListCookieJar listCookieJarSingleton = new ZodiacListCookieJar();

        address[] memory _list = new address[](2);
        _list[0] = makeAddr("alice");
        _list[1] = makeAddr("bob");

        bytes memory _initializerParams = abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken, _list);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "ListCookieJar";
        uint256 saltNonce = 1_234_567_890;

        cookieJarSummoner.summonCookieJar(
            address(listCookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        address cookieJar = _calculateCreate2Address(address(listCookieJarSingleton), _initializer, saltNonce);

        ZodiacListCookieJar listCookieJar = ZodiacListCookieJar(cookieJar);

        assertEq(listCookieJar.owner(), address(_safeTarget));
        assertEq(listCookieJar.allowList(_list[0]), true);
        assertEq(listCookieJar.allowList(_list[1]), true);
        assertEq(listCookieJar.allowList(cookieJar), false);
        assertEq(listCookieJar.avatar(), _safeTarget);
        assertEq(listCookieJar.target(), _safeTarget);
        assertEq(listCookieJar.cookieAmount(), _cookieAmount);
        assertEq(listCookieJar.cookieToken(), _cookieToken);
        assertEq(listCookieJar.periodLength(), _periodLength);
    }

    function testSummonOpenCookieJar() public {
        ZodiacOpenCookieJar openCookieJarSingleton = new ZodiacOpenCookieJar();

        bytes memory _initializerParams = abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "OpenCookieJar";
        uint256 saltNonce = 1_234_567_890;

        cookieJarSummoner.summonCookieJar(
            address(openCookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        address cookieJar = _calculateCreate2Address(address(openCookieJarSingleton), _initializer, saltNonce);

        ZodiacOpenCookieJar openCookieJar = ZodiacOpenCookieJar(cookieJar);

        assertEq(openCookieJar.owner(), address(_safeTarget));
        assertEq(openCookieJar.avatar(), _safeTarget);
        assertEq(openCookieJar.target(), _safeTarget);
        assertEq(openCookieJar.cookieAmount(), _cookieAmount);
        assertEq(openCookieJar.cookieToken(), _cookieToken);
        assertEq(openCookieJar.periodLength(), _periodLength);
    }

    function testSummonCookieJarWithDonationsNativeToken() public {
        ZodiacOpenCookieJar openCookieJarSingleton = new ZodiacOpenCookieJar();

        bytes memory _initializerParams = abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "CookieJarWithDonations";
        uint256 saltNonce = 1_234_567_890;

        vm.expectEmit(false, false, false, true);
        emit DonationReceived(address(0), 1 ether);
        cookieJarSummoner.summonCookieJar{ value: 1 ether }(
            address(openCookieJarSingleton), _initializer, details, address(0), 0, saltNonce
        );

        assertEq(address(0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc).balance, 1 ether);
    }

    function testSummonCookieJarWithDonationsERC20() public {
        ERC20Mintable donationToken = new ERC20Mintable("Test", "TEST");
        address alice = makeAddr("alice");

        donationToken.mint(alice, 10 ether);
        ZodiacOpenCookieJar openCookieJarSingleton = new ZodiacOpenCookieJar();

        bytes memory _initializerParams = abi.encode(_safeTarget, _periodLength, _cookieAmount, _cookieToken);
        bytes memory _initializer = abi.encodeWithSignature("setUp(bytes)", _initializerParams);

        string memory details = "CookieJarWithDonations";
        uint256 saltNonce = 1_234_567_890;

        vm.startPrank(alice);

        donationToken.approve(address(cookieJarSummoner), 1 ether);
        
        vm.expectEmit(false, false, false, true);
        emit DonationReceived(address(donationToken), 1 ether);
        cookieJarSummoner.summonCookieJar(
            address(openCookieJarSingleton), _initializer, details, address(donationToken), 1 ether, saltNonce
        );
        vm.stopPrank();

        assertEq(donationToken.balanceOf(0x1cE42BA793BA1E9Bf36c8b3f0aDDEe6c89D9a9fc), 1 ether);
    }
}
