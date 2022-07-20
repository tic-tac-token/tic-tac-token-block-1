// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

interface IGame {
    function getBoard(uint256 id) external view returns (uint256[9] memory);
}
