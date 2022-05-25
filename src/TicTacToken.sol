// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

interface IToken is IERC20 {
    function mint(address to, uint256 amount) external;
}

interface INFT is IERC721 {
    function mint(address to, uint256 tokenId) external;
}

contract TicTacToken {
    uint256 public constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;
    uint256 internal constant POINTS_PER_WIN = 5;

    address public owner;
    IToken public token;
    INFT public nft;
    uint256 internal nextGameId;

    struct Game {
        address playerX;
        address playerO;
        uint256 prevMove;
        uint256[9] board;
    }

    mapping(uint256 => Game) public games;
    mapping(address => uint256) public wins;

    constructor(
        address _owner,
        address _token,
        address _nft
    ) {
        owner = _owner;
        token = IToken(_token);
        nft = INFT(_nft);
    }

    modifier isPlayer() {
        require(
            msg.sender == games[0].playerX || msg.sender == games[0].playerO,
            "Unauthorized"
        );
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    function newGame(address playerX, address playerO) public {
        games[nextGameId].playerX = playerX;
        games[nextGameId].playerO = playerO;
        nextGameId++;

        (uint256 xTokenId, uint256 oTokenId) = tokenIds(nextGameId);
        nft.mint(playerX, xTokenId);
        nft.mint(playerO, oTokenId);
    }

    function tokenIds(uint256 gameId) public pure returns (uint256, uint256) {
        return (2 * gameId - 1, 2 * gameId);
    }

    function markSpace(uint256 id, uint256 space) public isPlayer {
        require(_validSpace(space), "Invalid space");
        require(_emptySpace(id, space), "Space already occupied");
        require(
            _validTurn(id, _getMarker(id)),
            "Turns should alternate between X and O"
        );

        games[id].board[space] = _getMarker(id);
        games[id].prevMove = _getMarker(id);

        uint256 _winner = winner(id);
        if (_winner != 0) {
            address winnerAddress = (_winner == X)
                ? games[id].playerX
                : games[id].playerO;
            wins[winnerAddress]++;
            token.mint(winnerAddress, POINTS_PER_WIN * 1 ether);
        }
    }

    function resetBoard(uint256 id) public isOwner {
        delete games[id].board;
    }

    function getBoard(uint256 id) public view returns (uint256[9] memory) {
        return games[id].board;
    }

    function winner(uint256 id) public view returns (uint256) {
        uint256[8] memory potentialWins = [
            _rowWin(id, 0),
            _rowWin(id, 1),
            _rowWin(id, 2),
            _colWin(id, 0),
            _colWin(id, 1),
            _colWin(id, 2),
            _diagWin(id),
            _antiDiagWin(id)
        ];
        for (uint256 i; i < potentialWins.length; i++) {
            if (potentialWins[i] != 0) {
                return potentialWins[i];
            }
        }
        return 0;
    }

    function _rowWin(uint256 id, uint256 row) internal view returns (uint256) {
        uint256 idx = row * 3;
        uint256 product = games[id].board[idx] *
            games[id].board[idx + 1] *
            games[id].board[idx + 2];
        return _checkWin(product);
    }

    function _colWin(uint256 id, uint256 col) internal view returns (uint256) {
        uint256 product = games[id].board[col] *
            games[id].board[col + 3] *
            games[id].board[col + 6];
        return _checkWin(product);
    }

    function _diagWin(uint256 id) internal view returns (uint256) {
        uint256 product = games[id].board[0] *
            games[id].board[4] *
            games[id].board[8];
        return _checkWin(product);
    }

    function _antiDiagWin(uint256 id) internal view returns (uint256) {
        uint256 product = games[id].board[2] *
            games[id].board[4] *
            games[id].board[6];
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

    function _getMarker(uint256 id) internal view returns (uint256) {
        if (msg.sender == games[id].playerX) return X;
        if (msg.sender == games[id].playerO) return O;
        return 0;
    }

    function _validSpace(uint256 space) internal pure returns (bool) {
        return space < 9;
    }

    function _validMarker(uint256 marker) internal pure returns (bool) {
        return marker == X || marker == O;
    }

    function _emptySpace(uint256 id, uint256 space)
        internal
        view
        returns (bool)
    {
        return games[id].board[space] == EMPTY;
    }

    function _validTurn(uint256 id, uint256 nextMove)
        internal
        view
        returns (bool)
    {
        return nextMove != games[id].prevMove;
    }
}
