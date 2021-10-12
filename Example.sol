// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import some contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// the contract inherits attributes and methods from the ERC721URIStorage contract
contract MyEpicNFT is ERC721URIStorage {
  // Stuff provived from open zeppelin to keep track of the tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // required to pass the name of our NFTs token and it's symbol.
  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is  my NFT contract. YEAH BABY");
  }
  
  // A function that our users will hit to get their NFT
  function makeAnEpicNFT() public {
    // Get the current token id, this starts at 0
    uint256 newItemId = _tokenIds.current();

    // Actually mint the NFT to the sender using msg.sender
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data
    _setTokenURI(newItemId, "blah");

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();
  }

}

