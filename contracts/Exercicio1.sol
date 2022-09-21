// SPDX-License-Identifier: UNLICENSED

// Versão a ser utilizada
pragma solidity ^0.8.9;

interface IExercicio {
    function questaoA(uint256) external returns(bytes32);
    function questaoB(uint256, uint256) external returns(bytes32);
    function questaoC(string memory) external returns(bytes32);
}

contract Exercicio1 is IExercicio{

    bytes32 public respostaA;
    bytes32 public respostaB;
    bytes32 public respostaC;

    /**
     *  @dev Recebe X e soma 5. Retornando o sha3 do valor 20 para a variavel respostaA
     */
    function questaoA(uint256 x) public returns(bytes32) {
        respostaA = keccak256(abi.encode(x + 5));
        return respostaA;
    }

    /**
     *  @dev Precisa retornar o sha3 do valor 100 para a variavel respostaA
     */
    function questaoB(uint256 x, uint256 y) public returns(bytes32) {
        respostaB = keccak256(abi.encode(x + y));
        return respostaB;
    }

    /**
     *  @dev Precisa retornar o keccak256 da string "Web3Dev"
     */
    function questaoC(string memory x) public returns(bytes32) {
        respostaC = keccak256(abi.encode(x));
        return respostaC;
    }

}

