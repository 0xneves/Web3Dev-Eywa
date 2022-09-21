/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
const { GOERLI,
        EYWA,
        STUDENT_1 
      } = process.env;

 module.exports = {
  solidity: "0.8.9",
  networks: {
    goerli: {
      url: `${GOERLI}`,
      accounts: [`${EYWA}`, `${STUDENT_1}`]
    }
  }
 }