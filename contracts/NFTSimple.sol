// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTSimple is ERC721 {
    constructor() public ERC721("MyNFT", "MNFT")  {
    }
}