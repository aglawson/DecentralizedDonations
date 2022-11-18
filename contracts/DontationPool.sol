// SPDX-License-Identifier: No License
pragma solidity 0.8.17;

import "./utils/ERC721A.sol";
import "./utils/Percentages.sol";
import "./utils/Ownable.sol";
import "./utils/ReentrancyGuard.sol";

contract DonationPool is ERC721A, Ownable, Percentages, ReentrancyGuard {

    event Withdraw(string entityName, uint256 amount);

    struct Entity {
        string name;
        address payable payReciever;
        uint256 lastWithdraw;
    }
    Entity[] public entities;
    mapping(string => uint256) public name_to_index;
    mapping(address => bool) public used_address;
    
    uint256 public price;

    constructor() ERC721A("DecentDono", "DONO") {
        entities.push(Entity("NULL", payable(address(0)), 0));
        price = 1000000000000000;
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
        entities.push(Entity(name, _payRecipient, 0));
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
        uint256 distribute = percentageOf(msg.value, 1);

        (bool success,) = entities[name_to_index[name]].payReciever.call{value: percentageOf(value, 95)}("");
        require(success, "Transfer fail");

        // need to replace this logic
        /**
         * ideas: instead of writing to each entity's payout variable, allow each 
         * entity to claim 1/entities.length once per 24 hourse (86400 seconds)
         * pros: no crazy for loops for writing
         * cons: disadvantage for users who don't remember to withdraw each day
         */
        // for(uint i = 0; i < entities.length; i++) {
        //     entities[i].payout += (distribute / entities.length);
        // }

    }

    function ownerWithdraw() external onlyOwner {
        require((block.timestamp - entities[0].lastWithdraw) > 86400, "Can only withdraw once per 24 hours");

        uint256 value = address(this).balance / entities.length;

        (bool success,) = payable(owner()).call{value: value}("");
        require(success, "Transfer fail");

        emit Withdraw('OWNER', value);
    }

    function entityWithdraw(string memory name) external {
        uint256 index = name_to_index[name];
        require(entities[index].payReciever == _msgSender(), "Caller is not designated receiver for entity");
        require((block.timestamp - entities[index].lastWithdraw) > 86400, "Can only withdraw once per 24 hours");
        entities[index].lastWithdraw = block.timestamp;

        uint256 value = address(this).balance / entities.length;

        (bool success,) = payable(entities[index].payReciever).call{value: value}("");
        require(success, "Transfer fail");

        emit Withdraw(name, value);
    }
}