// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";

contract Token is ERC20, Ownable {

    constructor() ERC20("Tic-Tac-Token", "TTT") {}

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

}
