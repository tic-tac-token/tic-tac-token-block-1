// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.15;

import "../lib/ds-test/src/test.sol";
import "../lib/forge-std/src/Vm.sol";

import "../contracts/Token.sol";

contract TestToken is DSTest {
    Token internal token;
    Vm public constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        token = new Token();
    }

    function test_token_has_name() public {
        assertEq(token.name(), "Tic-Tac-Token");
    }

    function test_token_has_symbol() public {
        assertEq(token.symbol(), "TTT");
    }

    function test_token_has_decimals() public {
        assertEq(token.decimals(), 18);
    }

    function test_mint() public {
        token.mint(address(42), 100 ether);
        assertEq(token.balanceOf(address(42)), 100 ether);
    }

    function test_supply_after_mint() public {
        token.mint(address(42), 100 ether);

        assertEq(token.totalSupply(), 100 ether);
    }

    function test_transfer() public {
        token.mint(address(42), 100 ether);

        vm.prank(address(42));
        token.approve(address(this), 100 ether);

        token.transferFrom(address(42), address(43), 100 ether);

        assertEq(token.balanceOf(address(43)), 100 ether);
    }

    function test_nonowner_cannot_mint() public {
        vm.startPrank(address(42));
        vm.expectRevert("Ownable: caller is not the owner");
        token.mint(address(42), 100 ether);
    }

    function test_contract_has_owner() public {
        assertEq(token.owner(), address(this));
    }
}
