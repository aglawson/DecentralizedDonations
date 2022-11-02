const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");

  describe("NFT", function () {
    this.beforeAll(async function() {
      /**
       * @dev initialize wallet instances
       * act as users of smart contracts
       */
      const [owner, addr2, addr3, addr4, addr5, addr6, addr7] = await ethers.getSigners();
      this.owner = owner;
      this.addr2 = addr2;
      this.addr3 = addr3;
      this.addr4 = addr4;
      this.addr5 = addr5;
      this.addr6 = addr6;
      this.addr7 = addr7;

      this.price = '10000000000000000';
      this.alPrice = '5000000000000000';

      this.NFT = await ethers.getContractFactory("NFT");
      this.nft = await this.NFT.deploy('Test NFT', 'TEST', 10000, '10000000000000000', '5000000000000000');
    });

  describe("Deployment", function () {
    it('deploys correctly', async function () {
      expect(await this.nft.name()).to.equal('Test NFT');
      expect(await this.nft.symbol()).to.equal('TEST');
      expect(await this.nft.maxSupply()).to.equal(10000);
      expect(await this.nft.price()).to.equal('10000000000000000');
      expect(await this.nft.alPrice()).to.equal('5000000000000000');
      expect(await this.nft.owner()).to.equal(this.owner.address);
    });

    it('initializes state to closed', async function () {
      await expect(this.nft.mint(1, [], {value: this.price})).to.be.revertedWith("Sale is closed");
    });
    
  });
});
