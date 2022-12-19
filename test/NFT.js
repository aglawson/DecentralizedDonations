const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const {MerkleTree} = require("merkletreejs");
const keccak256 = require("keccak256");

  describe("NFT", function () {
    this.beforeAll(async function() {
      /**
       * @dev initialize wallet instances
       * act as users of smart contracts
       */
      const [owner, addr2, addr3, addr4, addr5, addr6, addr7, wl1, wl2, wl3] = await ethers.getSigners();
      this.owner = owner;
      this.addr2 = addr2;
      this.addr3 = addr3;
      this.addr4 = addr4;
      this.addr5 = addr5;
      this.addr6 = addr6;
      this.addr7 = addr7;
      this.wl1 = wl1;
      this.wl2 = wl2;
      this.wl3 = wl3;

      this.wlAddresses = [this.wl1.address, this.wl2.address, this.wl3.address];

      this.leafNodes = this.wlAddresses.map(addr => keccak256(addr));
      this.merkleTree = new MerkleTree(this.leafNodes, keccak256, {sortPairs: true});
      this.root = this.merkleTree.getHexRoot();

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

  describe("Mint", async function () {
    it('allows public mint for correct price', async function () {
      await this.nft.setState(2);
      expect(await this.nft.mint(1,[],{value: this.price})).to.emit('Transfer');
    });

    it('owner can add to whitelist', async function () {
      await this.nft.setALRoot(this.root);
      expect(await this.nft.alRoot()).to.equal(this.root);

      const leaf = keccak256(this.wlAddresses[0]);

      const proof = this.merkleTree.getHexProof(leaf);
      expect(await this.nft.isAllowListed(this.wlAddresses[0], proof)).to.equal(true);
    });

    it('whitelisted address can mint for whitelist price', async function () {
      const leaf = keccak256(this.wlAddresses[0]);

      const proof = this.merkleTree.getHexProof(leaf);

      expect(await this.nft.connect(this.wl1).mint(1, proof, {value: this.alPrice})).to.emit('Transfer');
    });

    it('enforces whitelist only when in state 1', async function () {
      await this.nft.setState(1);
      await expect(this.nft.mint(1,[], {value: this.price})).to.be.revertedWith("NFT: Allow list only");
    });

    it('allows whitelist mint when in state 1', async function () {
      const leaf = keccak256(this.wlAddresses[1]);

      const proof = this.merkleTree.getHexProof(leaf);

      expect(await this.nft.connect(this.wl2).mint(1, proof, {value: this.alPrice})).to.emit('Transfer');
    });

  });

  describe('Security', async function () {
    it('does not allow non owner to call ownerMint', async function () {
        await expect(this.nft.connect(this.addr2).ownerMint(1,this.addr2.address)).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to withdraw', async function () {
        await expect(this.nft.connect(this.addr2).withdraw(1,this.addr2.address)).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to set URI', async function () {
        await expect(this.nft.connect(this.addr2).setURI('test URI')).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to set state', async function () {
        await expect(this.nft.connect(this.addr2).setState(1)).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to set alRoot', async function () {
        await expect(this.nft.connect(this.addr2).setALRoot(this.root)).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to call splitWithdraw', async function () {
        await expect(this.nft.connect(this.addr2).splitWithdraw()).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to change pay splits', async function () {
        await expect(this.nft.connect(this.addr2).changePaySplits(0, 100, this.addr2.address)).to.be.revertedWith('Ownable: caller is not the owner');
    });

    it('does not allow non owner to remove a pay split', async function () {
        await expect(this.nft.connect(this.addr2).removeFromPaySplits(1)).to.be.revertedWith('Ownable: caller is not the owner');
    });
  });
});
