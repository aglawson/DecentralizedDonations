# Library of helpful NFT related smart contracts

## Basic NFT Contract
```
  NFT
    Deployment
      ✓ deploys correctly
      ✓ initializes state to closed
    Mint
      ✓ allows public mint for correct price
      ✓ owner can add to whitelist
      ✓ whitelisted address can mint for whitelist price
      ✓ enforces whitelist only when in state 1
      ✓ allows whitelist mint when in state 1
    Security
      ✓ does not allow non owner to call ownerMint
      ✓ does not allow non owner to withdraw
      ✓ does not allow non owner to set URI
      ✓ does not allow non owner to set URI
      ✓ does not allow non owner to set state
      ✓ does not allow non owner to set alRoot
      ✓ does not allow non owner to call splitWithdraw
      ✓ does not allow non owner to change pay splits
      ✓ does not allow non owner to remove a pay split

·--------------------------|---------------------------|--------------|-------------------------------------·
|   Solc version: 0.8.17   ·  Optimizer enabled: true  ·  Runs: 2000  ·  Block limit: 9007199254740991 gas  │
···························|···························|··············|······································
|  Methods                 ·               21 gwei/gas                ·           1097.40 usd/eth           │
·············|·············|·············|·············|··············|···················|··················
|  Contract  ·  Method     ·  Min        ·  Max        ·  Avg         ·  # calls          ·  usd (avg)      │
·············|·············|·············|·············|··············|···················|··················
|  NFT       ·  mint       ·      95246  ·     108528  ·       99709  ·                3  ·           2.30  │
·············|·············|·············|·············|··············|···················|··················
|  NFT       ·  setALRoot  ·          -  ·          -  ·       46471  ·                1  ·           1.07  │
·············|·············|·············|·············|··············|···················|··················
|  NFT       ·  setState   ·      30294  ·      47394  ·       38844  ·                2  ·           0.90  │
·············|·············|·············|·············|··············|···················|··················
|  Deployments             ·                                          ·  % of limit       ·                 │
···························|·············|·············|··············|···················|··················
|  NFT                     ·          -  ·          -  ·     3674501  ·              0 %  ·          84.68  │
·--------------------------|-------------|-------------|--------------|-------------------|-----------------·

  16 passing (979ms)
```

## Donation Pool
```
  DonationPool
    Initialization
      ✓ owner initializes entity
    Minting
      ✓ can mint
    Distributing
      ✓ distributes ETH

·-----------------------------------|---------------------------|--------------|-------------------------------------·
|       Solc version: 0.8.17        ·  Optimizer enabled: true  ·  Runs: 2000  ·  Block limit: 9007199254740991 gas  │
····································|···························|··············|······································
|  Methods                          ·               62 gwei/gas                ·           1099.50 usd/eth           │
·················|··················|·············|·············|··············|···················|··················
|  Contract      ·  Method          ·  Min        ·  Max        ·  Avg         ·  # calls          ·  usd (avg)      │
·················|··················|·············|·············|··············|···················|··················
|  DonationPool  ·  addEntity       ·          -  ·          -  ·      105633  ·                1  ·           7.20  │
·················|··················|·············|·············|··············|···················|··················
|  DonationPool  ·  entityWithdraw  ·          -  ·          -  ·       37621  ·                1  ·           2.56  │
·················|··················|·············|·············|··············|···················|··················
|  DonationPool  ·  mint            ·          -  ·          -  ·       92474  ·                1  ·           6.30  │
·················|··················|·············|·············|··············|···················|··················
|  Deployments                      ·                                          ·  % of limit       ·                 │
····································|·············|·············|··············|···················|··················
|  DonationPool                     ·          -  ·          -  ·     3401832  ·              0 %  ·         231.90  │
·-----------------------------------|-------------|-------------|--------------|-------------------|-----------------·

  3 passing (815ms)
```