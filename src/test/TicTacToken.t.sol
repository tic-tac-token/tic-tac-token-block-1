// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";
import "../TicTacToken.sol";

contract Caller {
    TicTacToken internal ttt;

    constructor(TicTacToken _ttt) {
        ttt = _ttt;
    }

    function callMsgSender() public returns (address) {
        return ttt.msgSender();
    }
}

contract User {
    TicTacToken internal ttt;
    Vm internal vm;
    address internal userAddress;

    constructor(
        TicTacToken _ttt,
        Vm _vm,
        address _userAddress
    ) {
        ttt = _ttt;
        vm = _vm;
        userAddress = _userAddress;
    }

    function markSpace(uint256 space) public {
        vm.prank(userAddress);
        ttt.markSpace(space);
    }
}

contract TestTicTacToken is DSTest {
    uint256 constant EMPTY = 0;
    uint256 public constant X = 1;
    uint256 public constant O = 2;

    address public constant OWNER = address(1);
    address public constant PLAYER_X = address(2);
    address public constant PLAYER_O = address(3);
    address public constant NON_PLAYER = address(4);

    User internal playerX;
    User internal playerO;
    User internal nonPlayer;

    Vm public constant vm = Vm(HEVM_ADDRESS);
    TicTacToken internal ttt;

    function setUp() public {
        ttt = new TicTacToken(OWNER, PLAYER_X, PLAYER_O);
        playerX = new User(ttt, vm, PLAYER_X);
        playerO = new User(ttt, vm, PLAYER_O);
        nonPlayer = new User(ttt, vm, NON_PLAYER);
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
        playerX.markSpace(0);
        uint256[9] memory board = ttt.getBoard();
        assertEq(board[0], X);
    }

    function test_marks_first_square_with_o() public {
        playerO.markSpace(0);
        uint256[9] memory board = ttt.getBoard();
        assertEq(board[0], O);
    }

    function test_cannot_overwrite_marked_square() public {
        playerX.markSpace(2);

        vm.expectRevert("Space already occupied");
        playerO.markSpace(2);
    }

    function test_validates_marker_is_valid_index() public {
        vm.expectRevert("Invalid space");
        playerX.markSpace(9);
    }

    function test_validates_alternating_turns_with_x() public {
        playerX.markSpace(0);

        vm.expectRevert("Turns should alternate between X and O");
        playerX.markSpace(1);
    }

    function test_validates_alternating_turns_with_o() public {
        playerO.markSpace(0);

        vm.expectRevert("Turns should alternate between X and O");
        playerO.markSpace(1);
    }

    function test_checks_diagonal_win() public {
        playerX.markSpace(0);
        playerO.markSpace(1);
        playerX.markSpace(4);
        playerO.markSpace(2);
        playerX.markSpace(8);

        assertEq(ttt.winner(), X);
    }

    function test_checks_antidiagonal_win() public {
        playerX.markSpace(6);
        playerO.markSpace(1);
        playerX.markSpace(4);
        playerO.markSpace(3);
        playerX.markSpace(2);

        assertEq(ttt.winner(), X);
    }

    function xtest_checks_column_win() public {
        playerO.markSpace(0);
        playerX.markSpace(1);
        playerO.markSpace(3);
        playerX.markSpace(2);
        playerO.markSpace(6);

        assertEq(ttt.winner(), O);
    }

    function test_checks_row_win() public {
        playerX.markSpace(0);
        playerO.markSpace(3);
        playerX.markSpace(1);
        playerO.markSpace(4);
        playerX.markSpace(2);

        assertEq(ttt.winner(), X);
    }

    function test_checks_row_win2() public {
        playerO.markSpace(0);
        playerX.markSpace(3);
        playerO.markSpace(1);
        playerX.markSpace(4);
        playerO.markSpace(2);

        assertEq(ttt.winner(), O);
    }

    function test_checks_row_win3() public {
        playerO.markSpace(6);
        playerX.markSpace(3);
        playerO.markSpace(7);
        playerX.markSpace(4);
        playerO.markSpace(8);

        assertEq(ttt.winner(), O);
    }

    function test_checks_tie() public {
        playerX.markSpace(0);
        playerO.markSpace(1);
        playerX.markSpace(2);
        playerO.markSpace(3);
        playerX.markSpace(4);
        playerO.markSpace(5);
        playerX.markSpace(7);
        playerO.markSpace(6);

        // assertEq(ttt.winner(), 0);
    }

    function test_msg_sender() public {
        Caller caller1 = new Caller(ttt);
        Caller caller2 = new Caller(ttt);
        Caller caller3 = new Caller(ttt);

        assertEq(ttt.msgSender(), address(this));

        assertEq(caller1.callMsgSender(), address(caller1));
        assertEq(caller2.callMsgSender(), address(caller2));
        assertEq(caller3.callMsgSender(), address(caller3));
    }

    function test_non_owner_cannot_reset_board() public {
        vm.expectRevert("Unauthorized");
        ttt.resetBoard();
    }

    function test_owner_can_reset_board() public {
        vm.prank(OWNER);
        ttt.resetBoard();
    }

    function test_auth_non_player_cannot_mark_board() public {
        vm.expectRevert("Unauthorized");
        nonPlayer.markSpace(0);
    }

    function test_auth_playerX_can_mark_board() public {
        playerX.markSpace(0);
    }

    function test_auth_playerO_can_mark_board() public {
        playerO.markSpace(0);
    }
}
