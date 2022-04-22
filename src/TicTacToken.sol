// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

contract TicTacToken {
    uint256 public constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;
    uint256 internal prevMove;

    address public playerX;
    address public playerO;
    address public owner;

    uint256[9] public board;

    constructor(
        address _owner,
        address _playerX,
        address _playerO
    ) {
        owner = _owner;
        playerX = _playerX;
        playerO = _playerO;
    }

    function getBoard() public view returns (uint256[9] memory) {
        return board;
    }

    // possible?
    function _rowWin(uint256 row) internal view returns (uint256) {
        uint256 column = row * 3;
        /*

    Previous version:

    if ((board[column] + board[column + 1] + board[column + 2]) % 3 == 0) {
      return board[column];
    }

    However, this returns a false positive for some rows that add up to 3 but contain
    mixed symbols. For example:

    [0, 1, 2]
    [2, 0, 1]
    [1, 2, 0]
    etc...

    */
        uint256 product = board[column] * board[column + 1] * board[column + 2];
        if (product == 8) {
            return O;
        }
        if (product == 1) {
            return X;
        }
        return 0;
    }

    function _colWin(uint256 col) internal view returns (uint256) {}

    function _diagWin() internal view returns (uint256) {
        uint256 product = board[0] * board[4] * board[8];
        if (product == 8) {
            return O;
        }
        if (product == 1) {
            return X;
        }
        return 0;
    }

    function _antiDiagWin() internal view returns (uint256) {
        uint256 product = board[2] * board[4] * board[6];
        if (product == 8) {
            return O;
        }
        if (product == 1) {
            return X;
        }
        return 0;
    }

    function winner() public view returns (uint256) {
        uint256[5] memory potentialWins = [
            _rowWin(0),
            _rowWin(1),
            _rowWin(2),
            _diagWin(),
            _antiDiagWin()
        ];
        for (uint256 i; i < potentialWins.length; i++) {
            if (potentialWins[i] != 0) {
                return potentialWins[i];
            }
        }
        return 0;
    }

    function markSpace(uint256 space) public {
        require(_isPlayer(), "Unauthorized");
        require(_validSpace(space), "Invalid space");
        require(_emptySpace(space), "Space already occupied");
        require(
            _validTurn(_getMarker()),
            "Turns should alternate between X and O"
        );

        board[space] = _getMarker();
        prevMove = _getMarker();
    }

    function _getMarker() internal view returns (uint256) {
        if (msg.sender == playerX) return X;
        if (msg.sender == playerO) return O;
        return 0;
    }

    function resetBoard() public {
        require(msg.sender == owner, "Unauthorized");
        delete board;
    }

    function msgSender() public view returns (address) {
        return msg.sender;
    }

    function _isPlayer() internal view returns (bool) {
        return msg.sender == playerX || msg.sender == playerO;
    }

    function _validSpace(uint256 space) internal pure returns (bool) {
        return space < 9;
    }

    function _validMarker(uint256 marker) internal pure returns (bool) {
        return marker == X || marker == O;
    }

    function _emptySpace(uint256 space) internal view returns (bool) {
        return board[space] == EMPTY;
    }

    function _validTurn(uint256 nextMove) internal view returns (bool) {
        return nextMove != prevMove;
    }
}
