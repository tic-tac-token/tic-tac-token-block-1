// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

contract TicTacToken {

  uint256 constant public X = 1;
  uint256 constant public O = 2;

  uint256[9] public board;
  
  function getBoard() public view returns (uint256[9] memory) {
    return board;
  }

  function markSpace(uint256 space, uint256 marker) public {
    require(_validMarker(marker), "Invalid Marker");
    board[space] = marker;
  }

  function _validMarker(uint256 marker) internal pure returns (bool) {
      return marker == X || marker == O;
  }
}
