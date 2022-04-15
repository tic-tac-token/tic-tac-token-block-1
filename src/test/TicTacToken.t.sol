// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../TicTacToken.sol";

contract TestTicTacToken is DSTest {
    uint256 constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;

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

    function test_cannot_overwrite_marked_square() public {
        ttt.markSpace(2, X);

        vm.expectRevert("Space already occupied");
        ttt.markSpace(2, O);
    }

    function test_validates_marker_is_valid_index() public {
        vm.expectRevert("Invalid space");
        ttt.markSpace(9, X);
    }

    function test_validates_alternating_turns_with_x() public {
        ttt.markSpace(0, X);

        vm.expectRevert("Turns should alternate between X and O");
        ttt.markSpace(1, X);
    }

    function test_validates_alternating_turns_with_o() public {
        ttt.markSpace(0, O);

        vm.expectRevert("Turns should alternate between X and O");
        ttt.markSpace(1, O);
    }

    function test_checks_diagonal_win() public {
        ttt.markSpace(0, X);
        ttt.markSpace(1, O);
        ttt.markSpace(4, X);
        ttt.markSpace(2, O);
        ttt.markSpace(8, X);

        assertEq(ttt.winner(), X);
    }

    function test_checks_antidiagonal_win() public {
        ttt.markSpace(6, X);
        ttt.markSpace(1, O);
        ttt.markSpace(4, X);
        ttt.markSpace(3, O);
        ttt.markSpace(2, X);

        assertEq(ttt.winner(), X);
    }

    function xtest_checks_column_win() public {
        ttt.markSpace(0, O);
        ttt.markSpace(1, X);
        ttt.markSpace(3, O);
        ttt.markSpace(2, X);
        ttt.markSpace(6, O);

        assertEq(ttt.winner(), O);
    }

    function test_checks_row_win() public {
        ttt.markSpace(0, X);
        ttt.markSpace(3, O);
        ttt.markSpace(1, X);
        ttt.markSpace(4, O);
        ttt.markSpace(2, X);

        assertEq(ttt.winner(), X);
    }

    function test_checks_row_win2() public {
        ttt.markSpace(0, O);
        ttt.markSpace(3, X);
        ttt.markSpace(1, O);
        ttt.markSpace(4, X);
        ttt.markSpace(2, O);

        assertEq(ttt.winner(), O);
    }

    function test_checks_row_win3() public {
        ttt.markSpace(6, O);
        ttt.markSpace(3, X);
        ttt.markSpace(7, O);
        ttt.markSpace(4, X);
        ttt.markSpace(8, O);

        assertEq(ttt.winner(), O);
    }

    function test_checks_tie() public {
        ttt.markSpace(0, X);
        ttt.markSpace(1, O);
        ttt.markSpace(2, X);
        ttt.markSpace(3, O);
        ttt.markSpace(4, X);
        ttt.markSpace(5, O);
        ttt.markSpace(7, X);
        ttt.markSpace(6, O);

        // assertEq(ttt.winner(), 0);
    }
}
