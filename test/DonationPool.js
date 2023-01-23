// const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
// const { expect } = require("chai");
// const {MerkleTree} = require("merkletreejs");
// const keccak256 = require("keccak256");

//   describe("DonationPool", function () {
//     this.beforeAll(async function() {
//       /**
//        * @dev initialize wallet instances
//        * act as users of smart contracts
//        */
//       const [owner, addr2, addr3, addr4, addr5, addr6, addr7] = await ethers.getSigners();
//       this.owner = owner;
//       this.addr2 = addr2;
//       this.addr3 = addr3;
//       this.addr4 = addr4;
//       this.pay1 = addr5;
//       this.pay2 = addr6;
//       this.pay3 = addr7;

//       this.Dono = await ethers.getContractFactory("DonationPool");
//       this.dono = await this.Dono.deploy();
//     });

//     describe("Initialization", async function () {
//         it('owner initializes entity', async function () {
//             await this.dono.addEntity('entity1', this.pay1.address);
//             let entity = await this.dono.entities(1);

//             expect(entity[0]).to.equal('entity1');
//         });
//     });

//     describe("Minting", async function () {
//         it('can mint', async function () {
//             expect(await this.dono.connect(this.addr2).mint('entity1', 1, {value: await this.dono.price()})).to.emit('Transfer');
//         });

//         it('minting while there are many entities', async function () {
//             for(let i = 1; i < 25; i++) {
//                 await this.dono.addEntity(`entity${1+i}`, this.pay1.address);
//             }
//             expect(await this.dono.connect(this.addr2).mint('entity1', 1, {value: await this.dono.price()})).to.emit('Transfer');
//         });
//     });

//     describe("Distributing", async function () {
//         it('distributes ETH', async function () {
//             let entity = await this.dono.entities(1);
//             console.log(entity[2]);
//             expect(await this.dono.connect(this.pay1).entityWithdraw('entity1')).to.emit('Withdraw');
//         });
//     });

// });
