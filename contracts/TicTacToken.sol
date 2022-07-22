// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "./interfaces/INFT.sol";
import "./interfaces/IToken.sol";
import "./interfaces/IGame.sol";

contract TicTacToken is IGame {
    uint256 public constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;
    uint256 internal constant POINTS_PER_WIN = 5;

    IToken public immutable token;
    INFT public immutable nft;

    uint256 internal nextGameId;

    struct Game {
        address playerX;
        address playerO;
        uint256 prevMove;
        uint16 playerXBitmap;
        uint16 playerOBitmap;
    }

    mapping(uint256 => Game) public games;
    mapping(address => uint256) public wins;
    mapping(address => uint256[]) internal _gamesByPlayer;

    constructor(address _token, address _nft) {
        require(_token != address(0), "Zero token");
        require(_nft != address(0), "Zero NFT");
        token = IToken(_token);
        nft = INFT(_nft);
    }

    modifier isPlayer(uint256 id) {
        require(
            msg.sender == games[id].playerX || msg.sender == games[id].playerO,
            "Unauthorized"
        );
        _;
    }

    function newGame(address playerX, address playerO) public {
        require(playerX != address(0) && playerO != address(0), "Zero player");
        require(playerX != playerO, "Cannot play self");

        uint256 id = ++nextGameId;
        games[id].playerX = playerX;
        games[id].playerO = playerO;
        _gamesByPlayer[playerX].push(id);
        _gamesByPlayer[playerO].push(id);
        (uint256 xTokenId, uint256 oTokenId) = tokenIds(id);

        nft.mint(playerX, xTokenId);
        nft.mint(playerO, oTokenId);
    }

    function gamesByPlayer(address player)
        public
        view
        returns (uint256[] memory)
    {
        return _gamesByPlayer[player];
    }

    function tokenIds(uint256 gameId) public pure returns (uint256, uint256) {
        return (2 * gameId - 1, 2 * gameId);
    }

    function markSpace(uint256 id, uint256 space) public isPlayer(id) {
        require(_validSpace(space), "Invalid space");
        require(_emptySpace(id, space), "Already occupied");
        require(_validTurn(id, _getMarker(id)), "Not your turn");
        require(winner(id) == 0, "Game over");

        _setSymbol(id, space, _getMarker(id));
        games[id].prevMove = _getMarker(id);

        uint256 _winner = winner(id);
        if (winner(id) != 0) {
            address winnerAddress = (_winner == X)
                ? games[id].playerX
                : games[id].playerO;
            wins[winnerAddress]++;
            token.mint(winnerAddress, POINTS_PER_WIN * 1 ether);
        }
    }

    function _setSymbol(
        uint256 gameId,
        uint256 i,
        uint256 symbol
    ) internal {
        Game storage game = games[gameId];
        if (symbol == X) {
            game.playerXBitmap = _setBit(game.playerXBitmap, i);
        }
        if (symbol == O) {
            game.playerOBitmap = _setBit(game.playerOBitmap, i);
        }
    }

    function _readBit(uint16 bitMap, uint256 i) internal pure returns (uint16) {
        return bitMap & (uint16(1) << uint16(i));
    }

    function _setBit(uint16 bitMap, uint256 i) internal pure returns (uint16) {
        return bitMap | (uint16(1) << uint16(i));
    }

    function getBoard(uint256 id) public view returns (uint256[9] memory) {
        Game memory game = games[id];
        uint256[9] memory boardArray;
        for (uint256 i = 0; i < 9; ++i) {
            if (_readBit(game.playerXBitmap, i) != 0) {
                boardArray[i] = X;
            }
            if (_readBit(game.playerOBitmap, i) != 0) {
                boardArray[i] = O;
            }
        }
        return boardArray;
    }

    function winner(uint256 id) public view returns (uint256) {
        uint16[8] memory WIN_ENCODINGS = [7, 56, 448, 292, 146, 73, 273, 84];
        Game memory game = games[id];
        uint16 playerXBitmap = game.playerXBitmap;
        uint16 playerOBitmap = game.playerOBitmap;
        for (uint256 i = 0; i < WIN_ENCODINGS.length; ++i) {
            if (WIN_ENCODINGS[i] == (playerXBitmap & WIN_ENCODINGS[i])) {
                return X;
            } else if (WIN_ENCODINGS[i] == (playerOBitmap & WIN_ENCODINGS[i])) {
                return O;
            }
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

    function _emptySpace(uint256 id, uint256 space)
        internal
        view
        returns (bool)
    {
        Game memory game = games[id];
        return _readBit(game.playerXBitmap | game.playerOBitmap, space) == 0;
    }

    function _validTurn(uint256 id, uint256 nextMove)
        internal
        view
        returns (bool)
    {
        return nextMove != games[id].prevMove;
    }
}
