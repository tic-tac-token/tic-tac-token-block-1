// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "forge-std/Vm.sol";

import "openzeppelin-contracts/contracts/token/ERC721/utils/ERC721Holder.sol";
import "../NFT.sol";

contract TestNFT is DSTest, ERC721Holder {
    NFT internal nft;
    Vm public constant vm = Vm(HEVM_ADDRESS);

    function setUp() public {
        nft = new NFT();
    }

    function test_token_has_name() public {
        assertEq(nft.name(), "Tic-Tac-Token NFT");
    }

    function test_token_has_symbol() public {
        assertEq(nft.symbol(), "NFT");
    }

    function test_token_is_mintable() public {
        nft.mint(address(this), 1);
        assertEq(nft.balanceOf(address(this)), 1);
        assertEq(nft.ownerOf(1), address(this));
    }

    function test_token_is_not_mintable_by_nonowner() public {
        vm.prank(address(1));
        vm.expectRevert("Ownable: caller is not the owner");
        nft.mint(address(this), 1);
    }

    function test_token_has_uri() public {
        nft.mint(address(this), 1);
        assertEq(nft.tokenURI(1), "data:application/json;base64,eyJuYW1lIjoiR2FtZSAjMSIsImRlc2NyaXB0aW9uIjoiVGljLVRhYy1Ub2tlbiIsImltYWdlIjoiIn0=");
    }

    function test_token_has_json() public {
        assertEq(nft.tokenJSON(1), '{"name":"Game #1","description":"Tic-Tac-Token","image":""}');
        assertEq(nft.tokenJSON(2), '{"name":"Game #1","description":"Tic-Tac-Token","image":""}');
        assertEq(nft.tokenJSON(3), '{"name":"Game #2","description":"Tic-Tac-Token","image":""}');
    }
}
