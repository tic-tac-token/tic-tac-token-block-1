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

    modifier isPlayer() {
        require(msg.sender == playerX || msg.sender == playerO, "Unauthorized");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function markSpace(uint256 space) public isPlayer {
        require(_validSpace(space), "Invalid space");
        require(_emptySpace(space), "Space already occupied");
        require(
            _validTurn(_getMarker()),
            "Turns should alternate between X and O"
        );

        board[space] = _getMarker();
        prevMove = _getMarker();
    }

    function resetBoard() public isOwner {
        delete board;
    }

    function getBoard() public view returns (uint256[9] memory) {
        return board;
    }

    function winner() public view returns (uint256) {
        uint256[8] memory potentialWins = [
            _rowWin(0),
            _rowWin(1),
            _rowWin(2),
            _colWin(0),
            _colWin(1),
            _colWin(2),
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

    function _rowWin(uint256 row) internal view returns (uint256) {
        uint256 idx = row * 3;
        uint256 product = board[idx] * board[idx + 1] * board[idx + 2];
        return _checkWin(product);
    }

    function _colWin(uint256 col) internal view returns (uint256) {
        uint256 product = board[col] * board[col + 3] * board[col + 6];
        return _checkWin(product);
    }

    function _diagWin() internal view returns (uint256) {
        uint256 product = board[0] * board[4] * board[8];
        return _checkWin(product);
    }

    function _antiDiagWin() internal view returns (uint256) {
        uint256 product = board[2] * board[4] * board[6];
        return _checkWin(product);
    }

    function _checkWin(uint256 product) internal pure returns (uint256) {
        if (product == 8) {
            return O;
        }
        if (product == 1) {
            return X;
        }
        return 0;
    }

    function _getMarker() internal view returns (uint256) {
        if (msg.sender == playerX) return X;
        if (msg.sender == playerO) return O;
        return 0;
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
