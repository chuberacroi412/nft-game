// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract LipToken is ERC721, Ownable {
    uint256 COUNTER = 0;
    uint256 DNA_MOD = 10**16;
    uint256 RARITY_MOD = 100;

    uint256 fee = 1 ether;

    struct Lip {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    Lip[] public lips;

    event NewLip(address indexed owner, uint256 id, uint256 dna);

    constructor(string memory _name, string memory _symbol)
    ERC721(_name, _symbol) {}

    // Helper
    function _createRandomNum(uint256 _mod) internal view returns(uint256){
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));

        return randomNum % _mod;
    }

    function withdraw() external payable onlyOwner() {
        address payable _owner = payable(owner());
        _owner.transfer(address(this).balance);
    }

    function updateFee(uint256 _newFee) external onlyOwner() {
        fee = _newFee;
    }

    // Create a lip
    function _createLip(string memory _name) internal {

        uint8 rarity = uint8(_createRandomNum(RARITY_MOD));
        uint256 dna = _createRandomNum(DNA_MOD);

        Lip memory newLip = Lip(_name, COUNTER, dna, 1, rarity);
        lips.push(newLip);

        _safeMint(msg.sender, COUNTER);
        emit NewLip(msg.sender, COUNTER, dna);
        COUNTER++;
    }

    function createRandomLip(string memory _name) public payable {    
        require(msg.value >= fee, "The fee is not correct");
        _createLip(_name);
    }

    // Get all lips
    function getLips() public view returns(Lip[] memory) {
        return lips;
    }
}