const { ethers } = require("hardhat");
const { expect } = require("chai");
require("dotenv").config();
const { EYWA, STUDENT_1 } = process.env;

describe("Ambiente de teste", function () { 

    async function deployEywa(contractName) {
        const [ EYWA, STUDENT_1 ] = await ethers.getSigners()
        console.log("\n EYWA at address: ", EYWA.address)
        const factory = await ethers.getContractFactory(contractName, EYWA)
        const contract = await factory.deploy(EYWA.address)
        await contract.deployed()
        return contract
    }
    async function deployStudent(contractName) {
        const [ EYWA, STUDENT_1 ] = await ethers.getSigners()
        console.log("\n Student 1 at address: ", STUDENT_1.address)
        const factory = await ethers.getContractFactory(contractName, STUDENT_1)
        const contract = await factory.deploy()
        await contract.deployed()
        return contract
    }

    it("Ex 1: Deve fazer o deploy do exercicio 1", async function () {

        const EYWA = await deployEywa("EYWA")
        const Exercicio1 = await deployStudent("Exercicio1", STUDENT_1)
        
        const bytecode = Exercicio1.interface.encodeFunctionData(
            'questaoA(uint256)',
            [15]
        );
        console.log(bytecode)
        const tx = await EYWA.corrigirExercicio(1,1,Exercicio1.address,bytecode);

        // expect(await Exercicio1.respostaA()).to.be.equal(fodase)
        // expect(tx).to.be.equal(true);
    })

});