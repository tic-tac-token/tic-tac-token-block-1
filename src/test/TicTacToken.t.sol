// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../TicTacToken.sol";

contract TestTicTacToken is DSTest {

    uint256 constant EMPTY = 0;
    uint256 constant public X = 1;
    uint256 constant public O = 2;

    Vm public constant vm = Vm(HEVM_ADDRESS);
    TicTacToken internal ttt;

    function setUp() public {
        ttt = new TicTacToken();
    } 

    function test_first_square_of_board_is_empty() public {
        assertEq(ttt.board(0), EMPTY);
    }
    
    function test_last_square_of_board_is_empty() public {
        assertEq(ttt.board(8), EMPTY);
    }

    function test_full_board_starts_empty() public {
        for (uint256 i; i < 9; i++) {
            assertEq(ttt.board(i), EMPTY);
        }
    }

    function test_get_full_board() public {
        uint256[9] memory board = ttt.getBoard();
        for (uint256 i; i < 9; i++) {
            assertEq(board[i], EMPTY);
        } 
    }

    function test_marks_first_square_with_x() public {
        ttt.markSpace(0, X);
        uint256[9] memory board = ttt.getBoard();
        assertEq(board[0], X);
    }
    
    function test_marks_first_square_with_o() public {
        ttt.markSpace(0, O);
        uint256[9] memory board = ttt.getBoard();
        assertEq(board[0], O);
    }

    function test_validates_marker_is_x_or_o() public {
        ttt.markSpace(0, X);
        ttt.markSpace(1, O);
        
        vm.expectRevert("Invalid Marker");
        ttt.markSpace(3, 3);
    }
}
