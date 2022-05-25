// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/contracts/access/Ownable.sol";
import "openzeppelin-contracts/contracts/utils/Strings.sol";
import "openzeppelin-contracts/contracts/utils/Base64.sol";

interface IGame {
    function getBoard(uint256 id) external view returns (uint256[9] memory);
}

contract NFT is ERC721, Ownable {
    using Strings for uint256;

    mapping(uint256 => address) public gameByTokenId;

    constructor() ERC721("Tic-Tac-Token NFT", "NFT") {}

    function mint(address to, uint256 tokenId) public onlyOwner {
        gameByTokenId[tokenId] = msg.sender;
        _safeMint(to, tokenId);
    }

    function tokenSVG(uint256 tokenId) public view returns (string memory) {
        uint256 gameId = _gameId(tokenId);
        IGame game = IGame(gameByTokenId[tokenId]);
        uint256[9] memory board = game.getBoard(gameId);

        return
            string(
                abi.encodePacked(
                    '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
                    "<style>.text{font-family:monospace;font-size:48pt;letter-spacing:.25em;fill:white}</style>",
                    '<rect width="100%" height="100%" fill="#f0f9ff"/>',
                    _renderRow(0, board),
                    _renderRow(1, board),
                    _renderRow(2, board),
                    "</svg>"
                )
            );
    }

    function _renderRow(uint256 row, uint256[9] memory board)
        internal
        pure
        returns (string memory)
    {
        uint256 offset = (row + 1) * 25;
        uint256 idx = row * 3;
        return
            string(
                abi.encodePacked(
                    '<text x="50%" y="',
                    offset.toString(),
                    '%" class="text" dominant-baseline="middle" text-anchor="middle">',
                    _toSymbol(board[idx]),
                    _toSymbol(board[idx + 1]),
                    _toSymbol(board[idx + 2]),
                    "</text>"
                )
            );
    }

    function tokenJSON(uint256 tokenId) public view returns (string memory) {
        return
            string(
                abi.encodePacked(
                    '{"name":"',
                    _tokenName(tokenId),
                    '","description":"Tic-Tac-Token","image":"',
                    "",
                    '"}'
                )
            );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        returns (string memory)
    {
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(abi.encodePacked(tokenJSON(tokenId)))
                )
            );
    }

    function _toSymbol(uint256 marker) internal pure returns (string memory) {
        if (marker == 1) {
            return "X";
        } else if (marker == 2) {
            return "O";
        } else {
            return " ";
        }
    }

    function _tokenName(uint256 tokenId) internal view returns (string memory) {
        return string(abi.encodePacked("Game #", _gameId(tokenId).toString()));
    }

    function _gameId(uint256 tokenId) public pure returns (uint256) {
        uint256 gameId;
        if (tokenId % 2 == 0) {
            gameId = tokenId / 2;
        } else {
            gameId = (tokenId + 1) / 2;
        }
        return gameId;
    }
}
