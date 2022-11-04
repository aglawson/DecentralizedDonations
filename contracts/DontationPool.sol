// SPDX-License-Identifier: No License
pragma solidity 0.8.17;

import "./ERC721A.sol";
import "./Percentages.sol";
import "./Ownable.sol";
import "./ReentrancyGuard.sol";

contract DonationPool is ERC721A, Ownable, Percentages, ReentrancyGuard {
    struct Entity {
        string name;
        address payable payReciever;
    }
    Entity[] public entities;
    mapping(string => uint256) public name_to_index;
    mapping(address => bool) public used_address;
    
    uint256 public price;

    constructor(string memory name, string memory symbol, uint256 _price) ERC721A(name, symbol) {
        entities.push(Entity("NULL", payable(address(0))));
        price = _price;
    }

    function setPrice(uint256 _price) external onlyOwner {
        price = _price;
    }

    function isInitialized(string memory name) public view returns(bool) {
        uint256 index = name_to_index[name];
        return entities[index].payReciever != address(0);
    }

    function addEntity(string memory name, address payable _payRecipient) external onlyOwner {
        require(!isInitialized(name), "Name already in use");
        require(!used_address[_payRecipient], "Address already in use");
        name_to_index[name] = entities.length;
        entities.push(Entity(name, _payRecipient));
    }

    function removeEntity(string memory name) external onlyOwner {
        require(isInitialized(name), "Entity does not exist");
        used_address[entities[name_to_index[name]].payReciever] = false;
        entities[name_to_index[name]] = entities[entities.length - 1];
        entities.pop();
        name_to_index[name] = 0;
    }

    function mint(string memory name, uint256 amount) external payable nonReentrant{
        require(msg.value == price * amount, "Incorrect amount of ETH sent");
        require(isInitialized(name), "Entity does not exist");

        uint256 value = msg.value;

        (bool success,) = entities[name_to_index[name]].payReciever.call{value: percentageOf(value, 90)}("");
        require(success, "Transfer fail");
    }


    function withdraw() external onlyOwner {
        (bool success,) = payable(owner()).call{value: balanceOf(address(this))}("");
        require(success, "Transfer fail");
    }
}