const { ethers } = require("hardhat");
const { expect } = require("chai");
require("dotenv").config();
const { EYWA, STUDENT_1 } = process.env;
const { keccak256 } = require('js-sha3')

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

    it("Ex 1: Deve fazer o deploy do exercicio 1 e EYWA", async function () {

        const EYWA = await deployEywa("EYWA")
        const Exercicio1 = await deployStudent("Exercicio1", STUDENT_1)
                
        const resultadoA = 20;
        const abiPackedA = ethers.utils.solidityPack(["uint256"], [resultadoA]);
        const convertKeccak256A = ethers.utils.solidityKeccak256(["bytes"], [abiPackedA]);
        
        const resultadoB = 100;
        const abiPackedB = ethers.utils.solidityPack(["uint256"], [resultadoB]);
        const convertKeccak256B = ethers.utils.solidityKeccak256(["bytes"], [abiPackedB]);
        
        const resultadoC = "Web3Dev";
        const abiPackedC = ethers.utils.solidityPack(["string"], [resultadoC]);
        const convertKeccak256C = ethers.utils.solidityKeccak256(["bytes"], [abiPackedC]);

        await EYWA.inserirExercicio("https://web3dev.com.br", [
            convertKeccak256A,
            convertKeccak256B,
            convertKeccak256C
        ])

        const bytecodeA = Exercicio1.interface.encodeFunctionData(
            'questaoA(uint256)',
            [15]
        );
        const bytecodeB = Exercicio1.interface.encodeFunctionData(
            'questaoB(uint256,uint256)',
            [75,25]
        );
        const bytecodeC = Exercicio1.interface.encodeFunctionData(
            'questaoC(string)',
            ["Web3Dev"]
        );
        await EYWA.corrigirExercicio(1,0,Exercicio1.address,bytecodeA)
        await EYWA.corrigirExercicio(1,1,Exercicio1.address,bytecodeB)
        await EYWA.corrigirExercicio(1,2,Exercicio1.address,bytecodeC)
        console.log(abiPackedC)
        console.log(convertKeccak256C)
        console.log(await EYWA.getResultadoEsperado())
        console.log(await EYWA.getResultadoAluno())

    })

});