// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/utils/Strings.sol";

// divisible by three: print "fizz"
// divisible by five: print "buzz"
// divisible by both: print "fizzbuzz"
// otherwise: return the number as a string

contract FizzBuzz {

    function fizzbuzz(uint256 n) public pure returns (string memory) {
        if (n == 0) return "0";
        if (n % 3 == 0 && n % 5 == 0) {
            return "fizzbuzz";
        }
        if (n % 3 == 0) {
            return "fizz";
        }
        if (n % 5 == 0) {
            return "buzz";
        }
        return Strings.toString(n);
    }

}
