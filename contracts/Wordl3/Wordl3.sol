// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./Ownable.sol";
import "./ERC721.sol";

contract Wordl3 is Ownable, ERC721{
    using Strings for uint8;

    constructor(

    ) ERC721("3RDLE", "3RDLE") {

    }

    uint8[5] private word;
    uint256 public endTime;

    uint256 public totalSupply;
    mapping(uint256 => uint8) private token_type;

    mapping(address => uint8) public attemptsToday;
    mapping(address => bool) public won;
    mapping(address => uint256) public lastAttempt;
    mapping(address => uint256[]) public record;

    event guessed(address indexed player, uint8[5] guess, uint8[5] result, uint256 attempts, bool won);

    function setWord(uint8[5] calldata letters) public onlyOwner {
        endTime = block.timestamp + 86400;
        word = letters;
    }

    function guess(uint8[5] calldata letters) external returns(uint8[5] memory) {
        require(block.timestamp < endTime, "No Active Game");
        
        if(lastAttempt[_msgSender()] < endTime - 86400) {
            won[_msgSender()] = false;
            attemptsToday[_msgSender()] = 0;
        }
        require(!won[_msgSender()], "Already Won");
        require(attemptsToday[_msgSender()] < 6, "Can only attempt 6 times/day");

        lastAttempt[_msgSender()] = block.timestamp;
        attemptsToday[_msgSender()] += 1;

        uint8[5] memory result = check(letters);

        if(occurences(result, 1) == 5){
            won[_msgSender()] = true;
            record[_msgSender()].push(attemptsToday[_msgSender()]);

            token_type[totalSupply] = attemptsToday[_msgSender()];
            _mint(_msgSender(), totalSupply);
            totalSupply++;
        } else if(attemptsToday[_msgSender()] == 6) {
            record[_msgSender()].push(0);
        } 

        emit guessed(_msgSender(), letters, result, attemptsToday[_msgSender()], won[_msgSender()]);

        return result;
    }

    function check(uint8[5] calldata letters) private view returns(uint8[5] memory) {
        uint8[5] memory results = [0, 0, 0, 0, 0];
        uint8[26] memory accounted = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ,0 ,0];

        for(uint i = 0; i < word.length; i++) {
            if(letters[i] == word[i] && accounted[letters[i]] < occurences(word, letters[i])) {
                results[i] = 1;
                accounted[letters[i]]++;
            } else if(includes(word, letters[i])){
                if(accounted[letters[i]] < occurences(word, letters[i])){
                    accounted[letters[i]]++;
                    results[i] = 2;
                } else {
                    results[i] == 0;
                }
            } else {
                results[i] = 0;
            }
        }

        return results;
    }

    function includes(uint8[5] memory baseArray, uint value) public pure returns(bool) {
        for(uint i = 0; i < baseArray.length; i++) {
            if(baseArray[i] == value) {
                return true;
            }
        }

        return false;
    }

    function occurences(uint8[5] memory baseArray, uint value) public pure returns(uint) {
        uint occurs= 0;
        for(uint i = 0; i < baseArray.length; i++) {
            if(baseArray[i] == value) {
                occurs++;
            }
        }

        return occurs;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
        string memory baseURI = URI;
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, token_type[tokenId].toString())) : "";
    }

    function setUri(string calldata _uri) external onlyOwner {
        URI = _uri;
    }

    function withdraw() external onlyOwner {
        (bool success,) = payable(owner()).call{value: address(this).balance}("");
        require(success, "Transfer failed");
    }
}