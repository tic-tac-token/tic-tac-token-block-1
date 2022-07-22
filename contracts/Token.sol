// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

import "./interfaces/IToken.sol";

contract Token is IToken, ERC20, Ownable {
    constructor() ERC20("Tic-Tac-Token", "TTT") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
