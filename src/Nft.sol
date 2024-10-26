// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import {ERC721} from "solmate/tokens/ERC721.sol";
import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";
import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol";

error MintPriceNotPaid();
error MaxSupply();
error NonExistentTokenURI();
error WithdrawTransfer();

contract Nft is ERC721, Ownable{
    using Strings for uint256;

    string public baseURI;
    uint256 public currentTokenId;
    uint256 public constant TOTAL_SUPPLY = 10000;
    uint256 public constant MINT_PRICE = 0.08 ether;

    constructor( string memory _name, string memory _symbol) ERC721(_name, _symbol) Ownable(msg.sender){
        // baseURI = _baseURI;
    }

    function mintTo(address receipient) public payable returns (uint256 ){
        if (msg.value != MINT_PRICE) {
            revert MintPriceNotPaid();
        }
        uint256 newTokenId = ++currentTokenId;

        if (newTokenId > TOTAL_SUPPLY) {
            revert MaxSupply();
        }
        currentTokenId = newTokenId;
        _safeMint(receipient, newTokenId);
        return newTokenId;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert NonExistentTokenURI();
        }
        return 
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    
}



