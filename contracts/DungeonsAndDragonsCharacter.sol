// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";

contract DungeonsAndDragonsCharacter is ERC721, VRFConsumerBase {
    
    //Vars
    address public vrfCoordinator;
    bytes32 internal keyHash;
    uint256 internal fee;
    uint256 public randomResult;

    //Character Struct
    struct Character
    {
        uint256 strength;
        uint256 speed;
        uint256 stamina;
        string name;
    }

    //Characters array
    Character[] public characters;

    //Mappings
    mapping(bytes32 => string) requestToCharacterName;
    mapping(bytes32 => address) requestToSender;
    mapping(bytes32 => uint256) requestTokenId;


    constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash ) public 
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("DungeonsAndDragonsCharacter", "D&D")
    {

        vrfCoordinator = _VRFCoordinator;
        keyHash = _keyhash;
        fee = 0.1 * 10**18; //Link 
    }

    function requestNewRandomCharacter(uint256 userProvidedSeed, string memory name) public returns (bytes32)
    {
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestToCharacterName[requestId] = name;
        requestToSender[requestId] = msg.sender;

        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomNumber) internal override
    {
        //Random Generate Stats
        uint256 newId = characters.length;
        uint256 strength = (randomNumber % 100);
        uint256 speed = ((randomNumber %10000) / 100);
        uint256 stamina = ((randomNumber % 10000000) / 100000);

        //Create New Character and push him to our character array
        characters.push(Character(strength, speed, stamina, requestToCharacterName[requestId]));

        //Mint the NFT
        _safeMint(requestToSender[requestId], newId);
    }

    function setTokenURI(uint256 tokenId, string memory _tokenURI) public
    {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner");

        _setTokenURI(tokenId, _tokenURI);

    }
}