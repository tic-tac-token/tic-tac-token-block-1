// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../FizzBuzz.sol";

contract TestFizzBuzz is DSTest {
    FizzBuzz internal fizzbuzz;

    function setUp() public {
        fizzbuzz = new FizzBuzz();
    } 

    function test_prints_fizz_when_divisible_by_three() public {
        assertEq(fizzbuzz.fizzbuzz(3), "fizz");
    }

}
