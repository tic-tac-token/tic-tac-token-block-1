// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.15;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";

import "./interfaces/INFT.sol";
import "./interfaces/IGame.sol";

library Encoding {
    function toDataURI(string memory data, string memory mimeType)
        internal
        pure
        returns (string memory)
    {
        return
            string.concat(
                "data:",
                mimeType,
                ";base64,",
                Base64.encode(abi.encodePacked(data))
            );
    }
}

contract NFT is INFT, ERC721, Ownable {
    using Strings for uint256;
    using Encoding for string;

    mapping(uint256 => address) public gameByTokenId;
    string[6] colors = [
        "#f0f9ff",
        "#ecfdf5",
        "#fefce8",
        "#fff7ed",
        "#fef2f2",
        "#faf5ff"
    ];

    constructor() ERC721("Tic-Tac-Token NFT (Block 0x1)", "TTT.1 NFT") {}

    modifier tokenExists(uint256 tokenId) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        _;
    }

    function mint(address to, uint256 tokenId) public onlyOwner {
        gameByTokenId[tokenId] = msg.sender;

        _safeMint(to, tokenId);
    }

    function tokenSVG(uint256 tokenId)
        public
        view
        tokenExists(tokenId)
        returns (string memory)
    {
        uint256 gameId = _gameId(tokenId);
        IGame game = IGame(gameByTokenId[tokenId]);
        uint256[9] memory board = game.getBoard(gameId);

        return
            string.concat(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
                "<style>.text{font-family:monospace;font-size:48pt;letter-spacing:.25em;fill:#475569}</style>",
                '<rect width="100%" height="100%" fill="',
                _getColor(tokenId),
                '"/>',
                _renderRow(0, board),
                _renderRow(1, board),
                _renderRow(2, board),
                "</svg>"
            );
    }

    function tokenJSON(uint256 tokenId)
        public
        view
        tokenExists(tokenId)
        returns (string memory)
    {
        return
            string.concat(
                '{"name":"',
                _tokenName(tokenId),
                '","description":"Tic-Tac-Token NFT (Block 0x1)","image":"',
                tokenSVG(tokenId).toDataURI("image/svg+xml"),
                '"}'
            );
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override
        tokenExists(tokenId)
        returns (string memory)
    {
        return tokenJSON(tokenId).toDataURI("application/json");
    }

    function _getColor(uint256 tokenId) internal view returns (string memory) {
        return colors[colors.length % tokenId];
    }

    function _tokenName(uint256 tokenId) internal pure returns (string memory) {
        return string(abi.encodePacked("Game #", _gameId(tokenId).toString()));
    }

    function _renderRow(uint256 row, uint256[9] memory board)
        internal
        pure
        returns (string memory)
    {
        uint256 offset = (row + 1) * 25;
        uint256 idx = row * 3;
        return
            string.concat(
                '<text x="50%" y="',
                offset.toString(),
                '%" class="text" dominant-baseline="middle" text-anchor="middle">',
                _toSymbol(board[idx]),
                _toSymbol(board[idx + 1]),
                _toSymbol(board[idx + 2]),
                "</text>"
            );
    }

    function _toSymbol(uint256 marker) internal pure returns (string memory) {
        if (marker == 1) {
            return "X";
        } else if (marker == 2) {
            return "O";
        } else {
            return "_";
        }
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
