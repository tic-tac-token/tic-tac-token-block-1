// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "../lib/ds-test/src/test.sol";
import "../lib/forge-std/src/Vm.sol";

import "../lib/openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../contracts/NFT.sol";
import "../contracts/Token.sol";
import "../contracts/TicTacToken.sol";

contract MockGame {
    mapping(uint256 => uint256[9]) internal _boards;

    function getBoard(uint256 id) public view returns (uint256[9] memory) {
        return _boards[id];
    }

    function setBoard(uint256 gameId, uint256[9] memory board) external {
        _boards[gameId] = board;
    }
}

contract TestNFT is DSTest, ERC721Holder {
    uint256 constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;

    MockGame internal game;
    NFT internal nft;
    Vm public constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        game = new MockGame();
        nft = new NFT();
        nft.transferOwnership(address(game));
    }

    function test_token_has_name() public {
        assertEq(nft.name(), "Tic-Tac-Token NFT");
    }

    function test_token_has_symbol() public {
        assertEq(nft.symbol(), "NFT");
    }

    function test_token_is_mintable() public {
        vm.prank(address(game));
        nft.mint(address(this), 1);
        assertEq(nft.balanceOf(address(this)), 1);
        assertEq(nft.ownerOf(1), address(this));
    }

    function test_token_is_not_mintable_by_nonowner() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        nft.mint(address(this), 1);
    }

    function test_token_stores_game_address() public {
        vm.prank(address(game));
        nft.mint(address(this), 1);
        assertEq(nft.gameByTokenId(1), address(game));
    }

    function test_token_has_uri() public {
        vm.prank(address(game));
        nft.mint(address(this), 1);
        assertEq(
            nft.tokenURI(1),
            "data:application/json;base64,eyJuYW1lIjoiR2FtZSAjMSIsImRlc2NyaXB0aW9uIjoiVGljLVRhYy1Ub2tlbiIsImltYWdlIjoiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNDhjM1I1YkdVK0xuUmxlSFI3Wm05dWRDMW1ZVzFwYkhrNmJXOXViM053WVdObE8yWnZiblF0YzJsNlpUbzBPSEIwTzJ4bGRIUmxjaTF6Y0dGamFXNW5PaTR5TldWdE8yWnBiR3c2SXpRM05UVTJPWDA4TDNOMGVXeGxQanh5WldOMElIZHBaSFJvUFNJeE1EQWxJaUJvWldsbmFIUTlJakV3TUNVaUlHWnBiR3c5SWlObU1HWTVabVlpTHo0OGRHVjRkQ0I0UFNJMU1DVWlJSGs5SWpJMUpTSWdZMnhoYzNNOUluUmxlSFFpSUdSdmJXbHVZVzUwTFdKaGMyVnNhVzVsUFNKdGFXUmtiR1VpSUhSbGVIUXRZVzVqYUc5eVBTSnRhV1JrYkdVaVBpQWdJRHd2ZEdWNGRENDhkR1Y0ZENCNFBTSTFNQ1VpSUhrOUlqVXdKU0lnWTJ4aGMzTTlJblJsZUhRaUlHUnZiV2x1WVc1MExXSmhjMlZzYVc1bFBTSnRhV1JrYkdVaUlIUmxlSFF0WVc1amFHOXlQU0p0YVdSa2JHVWlQaUFnSUR3dmRHVjRkRDQ4ZEdWNGRDQjRQU0kxTUNVaUlIazlJamMxSlNJZ1kyeGhjM005SW5SbGVIUWlJR1J2YldsdVlXNTBMV0poYzJWc2FXNWxQU0p0YVdSa2JHVWlJSFJsZUhRdFlXNWphRzl5UFNKdGFXUmtiR1VpUGlBZ0lEd3ZkR1Y0ZEQ0OEwzTjJaejQ9In0="
        );
    }

    function test_uri_query_for_nonexistent_token() public {
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        nft.tokenURI(1);
    }

    function test_json_query_for_nonexistent_token() public {
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        nft.tokenJSON(1);
    }

    function test_svg_query_for_nonexistent_token() public {
        vm.expectRevert("ERC721Metadata: URI query for nonexistent token");
        nft.tokenSVG(1);
    }

    function test_token_has_json() public {
        game.setBoard(1, [EMPTY, X, EMPTY, EMPTY, O, EMPTY, X, O, EMPTY]);
        vm.startPrank(address(game));
        nft.mint(address(this), 1);
        nft.mint(address(this), 2);
        vm.stopPrank();

        string memory game1svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
                "<style>.text{font-family:monospace;font-size:48pt;letter-spacing:.25em;fill:#475569}</style>",
                '<rect width="100%" height="100%" fill="#f0f9ff"/>',
                '<text x="50%" y="25%" class="text" dominant-baseline="middle" text-anchor="middle">',
                " X ",
                "</text>",
                '<text x="50%" y="50%" class="text" dominant-baseline="middle" text-anchor="middle">',
                " O ",
                "</text>",
                '<text x="50%" y="75%" class="text" dominant-baseline="middle" text-anchor="middle">',
                "XO ",
                "</text>",
                "</svg>"
            )
        );
        string memory game1json = string(
            abi.encodePacked(
                '{"name":"Game #1","description":"Tic-Tac-Token","image":"',
                Encoding.toDataURI(game1svg, "image/svg+xml"),
                '"}'
            )
        );
        assertEq(
            nft.tokenJSON(1),
            game1json
        );
        assertEq(
            nft.tokenJSON(2),
            game1json
        );
    }

    function test_token_has_svg() public {
        game.setBoard(1, [EMPTY, X, EMPTY, EMPTY, O, EMPTY, X, O, EMPTY]);
        vm.prank(address(game));
        nft.mint(address(this), 1);

        string memory svg = string(
            abi.encodePacked(
                '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
                "<style>.text{font-family:monospace;font-size:48pt;letter-spacing:.25em;fill:#475569}</style>",
                '<rect width="100%" height="100%" fill="#f0f9ff"/>',
                '<text x="50%" y="25%" class="text" dominant-baseline="middle" text-anchor="middle">',
                " X ",
                "</text>",
                '<text x="50%" y="50%" class="text" dominant-baseline="middle" text-anchor="middle">',
                " O ",
                "</text>",
                '<text x="50%" y="75%" class="text" dominant-baseline="middle" text-anchor="middle">',
                "XO ",
                "</text>",
                "</svg>"
            )
        );
        assertEq(nft.tokenSVG(1), svg);
    }
}
