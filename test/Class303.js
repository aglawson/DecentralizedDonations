const { expect } = require("chai");
const { ethers } = require("hardhat");

  describe("Class303", function () {
    this.beforeAll(async function() {
      /**
       * @dev initialize wallet instances
       * act as users of smart contracts
       */
      const [owner, addr2, addr3, addr4, addr5, addr6, addr7] = await ethers.getSigners()
      this.owner = owner
      this.addr2 = addr2
      this.addr3 = addr3
      this.addr4 = addr4
      this.addr5 = addr5
      this.addr6 = addr6
      this.addr7 = addr7

      this.price = "50000000000000000"
      this.newPrice = "40000000000000000"

      this.uri = "baseURI1"
      this.newURI = "baseURI2"

      this.Class303 = await ethers.getContractFactory("Class303")
      this.c303 = await this.Class303.deploy(this.uri)
    });

  describe("Deployment", function () {
    it('does not allow mint of null class', async function () {
        await expect(this.c303.buyClass(0)).to.be.revertedWith("Class303: class does not exist")
    });
    
  });

  describe('Class Admin Functions', async function () {
    it('allows user to create a class', async function () {
        expect(await this.c303.connect(this.addr2).addClass('Test Class', this.price)).to.emit('classCreated')
    })

    it('allows class admin to update price', async function () {
        await this.c303.connect(this.addr2).changePrice(1, this.newPrice)
        const c = await this.c303.classes(1)
        expect(c.price).to.equal(this.newPrice)
    })
  });

  describe('Class Purchase', async function () {
    it('allows user to purchase a course', async function () {
        expect(await this.c303.connect(this.addr3).buyClass(1, {value: this.newPrice})).to.emit('classBought');
        expect(await this.c303.balanceOf(this.addr3.address, 1)).to.equal(1);
    })

    it('sends class admin price of class minus 10% fee', async function () {
        const before = await this.addr2.getBalance()
        await this.c303.connect(this.addr4).buyClass(1, {value: this.newPrice})
        const after = await this.addr2.getBalance()
        const diff = parseFloat(after) - parseFloat(before)

        const price = parseInt(this.newPrice)
        const fee = (price / 100) * 10
        const expected = price - fee

        //console.log('diff', (diff / 10**18).toFixed(6), 'expected', (expected / 10**18).toFixed(6))

        expect((diff / 10**18).toFixed(6)).to.equal((expected / 10**18).toFixed(6))
    })

    it('does not allow a user to buy a class they already own', async function () {
        await expect(this.c303.connect(this.addr3).buyClass(1, {value: this.newPrice})).to.be.revertedWith('Class303: already enrolled')
    })
  })

  describe('Security', async function () {
    it('does not allow non owner to withdraw', async function () {
        await expect(this.c303.connect(this.addr2).withdraw()).to.be.revertedWith('Ownable: caller is not the owner');
    })

    it('does not allow non owner to transfer ownership', async function () {
      await expect(this.c303.connect(this.addr4).transferOwnership(this.addr4.address)).to.be.revertedWith('Ownable: caller is not the owner');
    })

    it('does not allow non owner to change URI', async function () {
        await expect(this.c303.connect(this.addr2).setURI(this.newURI)).to.be.revertedWith('Ownable: caller is not the owner');
    })
  });
});