pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyCollectible is ERC721 {
    constructor() ERC721("MyNFT", "MNFT") public {
    }
}