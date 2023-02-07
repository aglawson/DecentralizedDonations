// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./ERC1155.sol";
import "../utils/Ownable.sol";

contract Class3 is ERC1155, Ownable {
    event classCreated(string name, address admin, uint256 price, uint256 classId);
    event classBought(string name, address student, uint256 paid, uint256 classId);

    modifier onlyClassAdmin(uint256 classId) {
        require(_msgSender() == classes[classId].admin, "Class3: caller is not class admin");
        _;
    }

    struct Class {
        string name;
        address admin;
        uint256 price;
        uint256 count;
        string _uri;
    }
    Class[] public classes;

    constructor() ERC1155("") {
        classes.push(Class("NULL", address(0), 0, 0, ""));
    }

    function addClass(string memory name, uint256 price, string memory _uri) external {
        require(price > 0, "Class3: price cannot be zero");
        uint256 classId = classes.length;
        classes.push(Class(name, _msgSender(), price, 0, _uri));

        emit classCreated(name, _msgSender(), price, classId);
    }

    function buyClass(uint256 classId) external payable {
        require(classes[classId].admin != address(0), "Class3: class does not exist");
        require(msg.value == classes[classId].price, "Class3: invalid value sent");

        _mint(_msgSender(), classId, 1, "");

        emit classBought(classes[classId].name, _msgSender(), msg.value, classId);
    }

    function uri(uint256 classId) public view override returns(string memory) {
        return classes[classId]._uri;
    }

    function changePrice(uint256 classId, uint256 price) external onlyClassAdmin(classId) {
        require(price > 0, "Class3: price cannot be zero");
        classes[classId].price = price;
    }

}