// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import some contract from OpenZeppelin
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";


// the contract inherits attributes and methods from the ERC721URIStorage contract
contract MyEpicNFT is ERC721URIStorage {
  // Stuff provived from open zeppelin to keep track of the tokenIds
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  uint256 constant max = 30;

  string topSvg = "<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 90 90'><defs><style>";
  string bottomSvg = ".cls-7{fill:#ffd400;}.cls-8{fill:#ffb600;}.cls-9{fill:none;stroke:#bfd7e2;stroke-linecap:round;stroke-linejoin:round;stroke-width:1.7px;}.cls-10{fill:#105a6b;}.cls-11{fill:#91bde5;}</style></defs><title>astronaut</title><g id='astronaut'><g id='astronaut-2' data-name='astronaut'><circle id='back' class='cls-1' cx='45' cy='45' r='42.5'/><g id='astronaut-3' data-name='astronaut'><path class='cls-2' d='M32.28,82.4v3.16A42.48,42.48,0,0,0,45,87.5V82.4Z'/><path class='cls-2' d='M45,79.29V71.51H38.78a3.11,3.11,0,0,1,0-6.22H45V56H32.28V79.29Z'/><path class='cls-3' d='M45,82.4v5.1a42.48,42.48,0,0,0,12.72-1.94V82.4Z'/><path class='cls-3' d='M51.22,65.29a3.11,3.11,0,0,1,0,6.22H45v7.78H57.72V56H45v9.33Z'/><polygon class='cls-4' points='32.28 79.29 32.28 82.4 45 82.4 57.72 82.4 57.72 79.29 45 79.29 32.28 79.29'/><path class='cls-5' d='M54.33,68.4a3.11,3.11,0,0,0-3.11-3.11H38.78a3.11,3.11,0,0,0-3.11,3.11Z'/><path class='cls-6' d='M54.33,68.4H35.67a3.11,3.11,0,0,0,3.11,3.11H51.22A3.11,3.11,0,0,0,54.33,68.4Z'/><path class='cls-3' d='M32.28,79.29V56H24.5a3.11,3.11,0,0,0-3.11,3.11v6.19h9.33v3.11H21.39v3.11h9.33v3.11H21.39v5.75a42.32,42.32,0,0,0,10.89,5.22V79.29Z'/><polygon class='cls-2' points='30.72 74.59 30.72 71.47 21.39 71.47 21.39 71.47 21.39 74.59 21.39 74.59 30.72 74.59'/><polygon class='cls-2' points='30.72 68.36 30.72 65.25 21.39 65.25 21.39 65.25 21.39 68.36 21.39 68.36 30.72 68.36'/><path class='cls-2' d='M59.28,74.87V71.75h9.33V68.64H59.28V65.53h9.33V59.07A3.11,3.11,0,0,0,65.5,56H57.72v29.6a42.32,42.32,0,0,0,10.89-5.22V74.87Z'/><polygon class='cls-3' points='59.28 71.75 59.28 74.87 68.61 74.87 68.61 74.87 68.61 71.75 68.61 71.75 59.28 71.75'/><polygon class='cls-3' points='59.28 65.53 59.28 68.64 68.61 68.64 68.61 68.64 68.61 65.53 68.61 65.53 59.28 65.53'/><path class='cls-2' d='M61,47.29a1.64,1.64,0,0,0,1.31-1.65V44a.6.6,0,0,1,.6-.6h0a1,1,0,0,0,1-1v-2.8a1,1,0,0,0-1-1h0a.6.6,0,0,1-.6-.6V36.39A1.64,1.64,0,0,0,61,34.75a1.58,1.58,0,0,0-1.84,1.55v9.44A1.58,1.58,0,0,0,61,47.29Z'/><path class='cls-7' d='M61.53,40.82a.86.86,0,0,1,.84.88,1.13,1.13,0,0,0,.22-.67,1.06,1.06,0,1,0-2.12,0,1.14,1.14,0,0,0,.22.67A.86.86,0,0,1,61.53,40.82Z'/><path class='cls-8' d='M61.53,42.14a1,1,0,0,0,.84-.44.84.84,0,1,0-1.68,0A1,1,0,0,0,61.53,42.14Z'/><path class='cls-4' d='M61.53,42.4A1.37,1.37,0,1,1,62.85,41,1.35,1.35,0,0,1,61.53,42.4Zm0-2.39a1,1,0,1,0,1,1A1,1,0,0,0,61.53,40Z'/><path class='cls-2' d='M29,47.29a1.64,1.64,0,0,1-1.31-1.65V44a.6.6,0,0,0-.6-.6h0a1,1,0,0,1-1-1v-2.8a1,1,0,0,1,1-1h0a.6.6,0,0,0,.6-.6V36.39A1.64,1.64,0,0,1,29,34.75a1.58,1.58,0,0,1,1.84,1.55v9.44A1.58,1.58,0,0,1,29,47.29Z'/><path class='cls-7' d='M28.85,40.82a.86.86,0,0,1,.84.88,1.13,1.13,0,0,0,.22-.67,1.06,1.06,0,1,0-2.12,0,1.14,1.14,0,0,0,.22.67A.86.86,0,0,1,28.85,40.82Z'/><path class='cls-8' d='M28.85,42.14a1,1,0,0,0,.84-.44.84.84,0,1,0-1.68,0A1,1,0,0,0,28.85,42.14Z'/><path class='cls-4' d='M28.85,42.4A1.37,1.37,0,1,1,30.17,41,1.35,1.35,0,0,1,28.85,42.4Zm0-2.39a1,1,0,1,0,1,1A1,1,0,0,0,28.85,40Z'/><path class='cls-4' d='M36.05,45.07H53.95a3.8,3.8,0,0,1,3.8,3.8v13a0,0,0,0,1,0,0H32.25a0,0,0,0,1,0,0v-13A3.8,3.8,0,0,1,36.05,45.07Z'/><path class='cls-2' d='M29.27,38.11a15.73,15.73,0,1,1,31.45,0v6.62c0,7.77-7,14.07-15.73,14.07S29.27,52.5,29.27,44.73Z'/><path class='cls-9' d='M29.27,38.37c0-4.8,7-8.69,15.73-8.69s15.73,3.89,15.73,8.69'/><path class='cls-9' d='M60.73,43.49c0,4.8-7,8.69-15.73,8.69s-15.73-3.89-15.73-8.69'/><path class='cls-1' d='M60.33,38.5v4.85c0,4.55-6.87,8.23-15.33,8.23s-15.33-3.9-15.33-8.45V38.5c0-4.54,6.87-8.22,15.33-8.22S60.33,34,60.33,38.5Z'/><path class='cls-1' d='M45,51.58c8.47,0,15.33-3.68,15.33-8.23V40.79s0,.09,0,.13c-.13-4.48-6.94-8.09-15.32-8.09Z'/><path class='cls-10' d='M45,32.84c-8.32,0-15.07,3.55-15.31,8,0-.08,0-.16,0-.24v2.56c0,4.55,6.87,8.45,15.33,8.45Z'/></g><g id='stars'><circle class='cls-11' cx='31.39' cy='12.59' r='0.52'/><circle class='cls-11' cx='12.87' cy='30.01' r='0.43'/><circle class='cls-11' cx='22.04' cy='24.3' r='0.43'/><circle class='cls-11' cx='33.78' cy='21.31' r='0.33'/><circle class='cls-11' cx='76.49' cy='31.95' r='0.43'/><circle class='cls-11' cx='14.61' cy='55.05' r='0.33'/><circle class='cls-11' cx='69.2' cy='52.2' r='0.43'/><circle class='cls-11' cx='64.01' cy='29.58' r='0.43'/><circle class='cls-11' cx='19.48' cy='49.36' r='0.43'/><circle class='cls-11' cx='77.13' cy='43.51' r='0.43'/><circle class='cls-11' cx='70.64' cy='25.81' r='0.33'/><circle class='cls-11' cx='59.17' cy='16.35' r='0.33'/><circle class='cls-11' cx='45.77' cy='12.28' r='0.31'/><circle class='cls-11' cx='15.8' cy='40.57' r='0.54'/></g></g></g></svg>";

  string[] spaceColors = ["#073349", "#000000", "#1D4044", "#1C4532", "#1A365D", "#322659" ];
  string[] skinColors = ["#d7ebf4", "#1A202C", "#bfd7e2",  "#aac7d1", "#e84505",  "#bc350c", "#38A169",  "#2F855A", "#319795", "#2C7A7B", "#805AD5",  "#6B46C1",  "#D53F8C", "#B83280"];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  // required to pass the name of our NFTs token and it's symbol.
  constructor() ERC721 ("AstronautNFT", "ASTRONAUT") {
    console.log("This is  my NFT contract. YEAH BABY");
  }

  function pickRandomSpaceColor(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("SPACE_COLOR", Strings.toString(tokenId))));

    rand = rand % spaceColors.length;
    return spaceColors[rand];
  }

  function pickRandomSkinColor(uint256 tokenId, string memory input) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(input, Strings.toString(tokenId))));
    rand = rand % skinColors.length;
    return skinColors[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function getTotalNFTsMintedSoFar() public view returns (uint256)  {
    return _tokenIds.current(); 
  }
  
  // A function that our users will hit to get their NFT
  function makeAnEpicNFT() public {
    // Get the current token id, this starts at 0
    uint256 newItemId = _tokenIds.current();

    require(newItemId < max,"Can't create more NFTs");

    string memory spaceColor = pickRandomSpaceColor(newItemId);
    string memory helmetColor = pickRandomSkinColor(newItemId, "HELMET");
    string memory jacketColor = pickRandomSkinColor(newItemId, "JACKET");
    string memory neckColor = pickRandomSkinColor(newItemId, "NECK");
    string memory chestTopColor = pickRandomSkinColor(newItemId, "CHEST_TOP");
    string memory chestBottomColor = pickRandomSkinColor(newItemId, "CHEST_BOTTOM");

    spaceColor = string(abi.encodePacked(".cls-1{fill:", spaceColor, ";}"));
    helmetColor = string(abi.encodePacked(".cls-2{fill:", helmetColor, ";}"));
    jacketColor = string(abi.encodePacked(".cls-3{fill:", jacketColor, ";}"));
    neckColor = string(abi.encodePacked(".cls-4{fill:", neckColor, ";}"));
    chestTopColor = string(abi.encodePacked(".cls-5{fill:", chestTopColor, ";}"));
    chestBottomColor = string(abi.encodePacked(".cls-6{fill:", chestBottomColor, ";}"));

    string memory middleSvg = string(abi.encodePacked(spaceColor, helmetColor, jacketColor, neckColor, chestTopColor, chestBottomColor));

    string memory finalSvg = string(abi.encodePacked(topSvg, middleSvg, bottomSvg));


    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    "Epic random and original astronaut avatar",
                    '", "description": "A pretty cool and unique astronaut avatar.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    // prepend data:application/json;base64, to our data
    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    // Actually mint the NFT to the sender using msg.sender
    _safeMint(msg.sender, newItemId);

    // Set the NFTs data
    _setTokenURI(newItemId, finalTokenUri);

    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    // Increment the counter for when the next NFT is minted.
    _tokenIds.increment();

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }

}

