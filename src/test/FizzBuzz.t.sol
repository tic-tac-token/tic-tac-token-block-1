// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../FizzBuzz.sol";

import "openzeppelin-contracts/contracts/utils/Strings.sol";

contract TestFizzBuzz is DSTest {
    Vm public constant vm = Vm(HEVM_ADDRESS);
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    } 

    function test_prints_fizz_when_divisible_by_three(uint256 n) public {
        vm.assume(n != 0);
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 != 0);

        assertEq(fizzbuzz.fizzbuzz(n), "fizz");
    }

    function test_prints_buzz_when_divisible_by_five(uint256 n) public {
        vm.assume(n != 0);
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 == 0);

        assertEq(fizzbuzz.fizzbuzz(n), "buzz");
    }

    function test_prints_fizzbuzz_when_divisible_by_three_and_five(uint256 n) public {
        vm.assume(n != 0);
        vm.assume(n % 3 == 0);
        vm.assume(n % 5 == 0);
        
        assertEq(fizzbuzz.fizzbuzz(n), "fizzbuzz");
    }

    function test_prints_number_as_string_when_non_divisible(uint256 n) public {
        vm.assume(n % 3 != 0);
        vm.assume(n % 5 != 0);
        
        assertEq(fizzbuzz.fizzbuzz(n), Strings.toString(n));
    }

}
