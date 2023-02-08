# NFT Library
## Collection of NFT smart contracts for cool use cases

* [NFT](https://github.com/aglawson/NFTLibrary/blob/main/contracts/NFT.sol)
  - Description: Basic NFT smart contract. Features whitelist functionality using Merkle Tree and sha256 cryptography. 
  
* [Class303](https://github.com/aglawson/NFTLibrary/blob/main/contracts/Membership/Class303.sol)
  - Description: Smart contract to facilitate a blockchain based, peer-to-peer course platform. Similar to Udemy.

```
  Class303
    Deployment
      ✔ does not allow mint of null class (40ms)
    Class Admin Functions
      ✔ allows user to create a class
      ✔ allows class admin to update price
    Class Purchase
      ✔ allows user to purchase a course (45ms)
      ✔ sends class admin price of class minus 10% fee
      ✔ does not allow a user to buy a class they already own
    Security
      ✔ does not allow non owner to withdraw
      ✔ does not allow non owner to transfer ownership
      ✔ does not allow non owner to change URI

  NFT
    Deployment
      ✔ deploys correctly (49ms)
      ✔ initializes state to closed
    Mint
      ✔ allows public mint for correct price (41ms)
      ✔ owner can add to whitelist
      ✔ whitelisted address can mint for whitelist price
      ✔ enforces whitelist only when in state 1
      ✔ allows whitelist mint when in state 1
    Security
      ✔ does not allow non owner to call ownerMint
      ✔ does not allow non owner to withdraw
      ✔ does not allow non owner/admin to set URI
      ✔ does not allow non owner/admin to set state
      ✔ does not allow non owner/admin to set alRoot
      ✔ does not allow non owner to transfer ownership
      ✔ does not allow non owner/admin to set price
      ✔ does not allow non owner/admin to set allow list price


  24 passing (2s)
  ```