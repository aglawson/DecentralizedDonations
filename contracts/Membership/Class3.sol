// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./ERC1155.sol";
import "../utils/Ownable.sol";

contract Class3 is ERC1155, Ownable {
    event classCreated(string name, address admin, uint256 price, uint256 classId);
    event classBought(string name, address student, uint256 paid, uint256 classId);

    string public baseURI;

    modifier onlyClassAdmin(uint256 classId) {
        require(_msgSender() == classes[classId].admin, "Class3: caller is not class admin");
        _;
    }

    struct Class {
        string name;
        address admin;
        uint256 price;
        uint256 count;
    }
    Class[] public classes;

    constructor(string memory _baseURI) ERC1155(_baseURI) {
        classes.push(Class("NULL", address(0), 0, 0));
        baseURI = _baseURI;
    }

    function addClass(string memory name, uint256 price, string memory _uri) external {
        require(price > 0, "Class3: price cannot be zero");
        uint256 classId = classes.length;
        classes.push(Class(name, _msgSender(), price, 0));

        emit classCreated(name, _msgSender(), price, classId);
    }

    function buyClass(uint256 classId) external payable {
        require(classes[classId].admin != address(0), "Class3: class does not exist");
        require(msg.value == classes[classId].price, "Class3: invalid value sent");

        _mint(_msgSender(), classId, 1, "");

        emit classBought(classes[classId].name, _msgSender(), msg.value, classId);
    }

    function uri(uint256 classId) public view override returns(string memory) {
        return string(abi.encodePacked(baseURI, _toString(classId)));
    }

    function changePrice(uint256 classId, uint256 price) external onlyClassAdmin(classId) {
        require(price > 0, "Class3: price cannot be zero");
        classes[classId].price = price;
    }

        /**
     * @dev Converts a uint256 to its ASCII string decimal representation.
     */
    function _toString(uint256 value) internal pure virtual returns (string memory str) {
        assembly {
            // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
            // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
            // We will need 1 word for the trailing zeros padding, 1 word for the length,
            // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
            let m := add(mload(0x40), 0xa0)
            // Update the free memory pointer to allocate.
            mstore(0x40, m)
            // Assign the `str` to the end.
            str := sub(m, 0x20)
            // Zeroize the slot after the string.
            mstore(str, 0)

            // Cache the end of the memory to calculate the length later.
            let end := str

            // We write the string from rightmost digit to leftmost digit.
            // The following is essentially a do-while loop that also handles the zero case.
            // prettier-ignore
            for { let temp := value } 1 {} {
                str := sub(str, 1)
                // Write the character to the pointer.
                // The ASCII index of the '0' character is 48.
                mstore8(str, add(48, mod(temp, 10)))
                // Keep dividing `temp` until zero.
                temp := div(temp, 10)
                // prettier-ignore
                if iszero(temp) { break }
            }

            let length := sub(end, str)
            // Move the pointer 32 bytes leftwards to make room for the length.
            str := sub(str, 0x20)
            // Store the length.
            mstore(str, length)
        }
    }

}