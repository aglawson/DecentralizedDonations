require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
const dotenv = require("dotenv");
dotenv.config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: 'hardhat',
  networks: {
      hardhat: {
          allowUnlimitedContractSize: true,
          gas: 12000000,
          blockGasLimit: 0x1fffffffffffff,

      },
      mainnet: {
          url: 'https://eth.golom.io',
      },
  },
  solidity: {
      compilers: [
          {
              version: '0.8.17',
              settings: {
                  optimizer: {
                      enabled: true,
                      runs: 2000,
                  },
              },
          },
          {
              version: '0.4.18',
          },
          {
              version: '0.8.11',
          },
          {
              version: '0.8.0',
          },
          {
              version: '0.5.3',
          },
      ],
  },
  paths: {
    sources: "./contracts/mainnet",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  watcher: {
    compile: {
      tasks: ["compile"],
    },
    test: {
      tasks: ["test"],
    },
  },
  gasReporter: {
      currency: 'USD',
      gasPrice: 62,
      coinmarketcap: process.env.coinmarketcap,
      enabled: true
  },

  etherscan: {
      // Your API key for Etherscan
      // Obtain one at https://etherscan.io/
      apiKey: 'YOUR_ETHERSCAN_API_KEY',
  },
};

