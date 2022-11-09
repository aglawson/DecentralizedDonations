// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./ERC721A.sol";
import "./ReentrancyGuard.sol";
import "./MerkleProof.sol";
import "./Percentages.sol";
import "./Ownable.sol";
contract NFT is ERC721A, Ownable, ReentrancyGuard, Percentages {
    // Max supply 
    uint256 public maxSupply;

    // Merkle Root
    bytes32 public alRoot;

    uint256 public price;
    uint256 public alPrice;

    // 0 - closed
    // 1 - allow list only
    // 2 - public
    uint256 public state;
    
    event minted(address minter, uint256 price, address recipient, uint256 amount);
    event stateChanged(uint256 _state);
    event genesisChanged(address _project);

    struct Wallets {
        uint256 percentage;
        address wallet;
    }
    Wallets[] public wallets;

    constructor(
        string memory name,     // 
        string memory symbol,   // 
        uint256 _maxSupply,     // 
        uint256 _price,         // 
        uint256 _alPrice        //
    ) 
    ERC721A(name, symbol) 
    {
        maxSupply = _maxSupply;
        price = _price;
        alPrice = _alPrice;
        
        // wallets.push(Wallets(35, 0x...));
        // wallets.push(Wallets(25, 0x...));
        // wallets.push(Wallets(15, 0x...));
        // wallets.push(Wallets(10, 0x...));
        // wallets.push(Wallets(8, 0x...));
        // wallets.push(Wallets(5, 0x...));
        // wallets.push(Wallets(2, 0x...));
    }

    function isAllowListed(address _recipient, bytes32[] calldata _merkleProof) public view returns(bool) {
        bytes32 leaf = keccak256(abi.encodePacked(_recipient));
        bool isal = MerkleProof.verify(_merkleProof, alRoot, leaf);
        return isal;
    }

    function mint(uint256 amount, bytes32[] calldata _merkleProof) external payable nonReentrant {
        require(state > 0, "Sale is closed");
        require(totalSupply() + amount <= maxSupply, "NFT: exceeds max supply");

        uint256 mintPrice = price;

        if(state == 1) {
            require(isAllowListed(_msgSender(), _merkleProof), "NFT: Allow list only");
            mintPrice = alPrice;
        } else if(state == 2) {
            if(isAllowListed(_msgSender(), _merkleProof)) {
                mintPrice = alPrice;
            }
        }

        require(msg.value == mintPrice * amount, "NFT: incorrect amount of ETH sent");
        
        _safeMint(_msgSender(), amount);
        emit minted(_msgSender(), msg.value, _msgSender(), amount);
    }

    function ownerMint(uint amount, address _recipient) external onlyOwner {
        require(totalSupply() + amount <= maxSupply,  "exceeds max supply");
        _safeMint(_recipient, amount);
        emit minted(_msgSender(), 0, _recipient, amount);
    }

    function withdraw(uint256 amount, address payable recipient) external onlyOwner {
        (bool success,) = recipient.call{value: amount}("");
        require(success, "Transfer fail");
    }

    function setURI(string memory _uri) external onlyOwner {
        URI = _uri;
    }

    function setState(uint256 _state) external onlyOwner {
        require(_state <= 6, "State can only be from 0 to 6, inclusive");
        state = _state;
        emit stateChanged(state);
    }
    
    function setALRoot(bytes32 root) external onlyOwner {
        alRoot = root;
    }

    function splitWithdraw() external onlyOwner nonReentrant{
        require(wallets.length > 0, "NFT: no wallets initialized for payment");
        uint256 balance = address(this).balance;

        for(uint256 i = 0; i < wallets.length; i++) {
            uint256 payout = percentageOf(balance, wallets[i].percentage);
            (bool success,) = wallets[i].wallet.call{value: payout }("");
            require(success, 'Transfer fail');
        }
    }

    function changePaySplits(uint256 indexToChange, uint256 _percentage, address payable _wallet) external onlyOwner {
        wallets[indexToChange].percentage = _percentage;
        wallets[indexToChange].wallet = _wallet;
    }

    function addToPaySplits(uint256 _percentage, address payable _wallet) external onlyOwner {
        wallets.push(Wallets(_percentage, _wallet));
    }

    function removeFromPaySplits(uint256 index) external onlyOwner {
        wallets[index] = wallets[wallets.length - 1];
        wallets.pop();
    }
}
