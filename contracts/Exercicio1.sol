// SPDX-License-Identifier: UNLICENSED

// Versão a ser utilizada
pragma solidity ^0.8.9;

interface IExercicio {
    function questaoA(uint256) external returns(uint256);
    function questaoB(uint256, uint256) external returns(uint256);
    function questaoC(string memory) external returns(string memory);
}

contract Exercicio1 is IExercicio{

    uint256 public respostaA; // 20
    uint256 public respostaB; // 100
    string public respostaC; // "Web3Dev"

    /**
     *  @dev Recebe X e soma 5. Retornando o sha3 do valor 20 para a variavel respostaA
     */
    function questaoA(uint256 x) public returns(uint256) {
        respostaA = x+5;
        return respostaA;
    }

    /**
     *  @dev Precisa retornar o sha3 do valor 100 para a variavel respostaA
     */
    function questaoB(uint256 x, uint256 y) public returns(uint256) {
        respostaB = x+y;
        return respostaB;
    }

    /**
     *  @dev Precisa retornar o keccak256 da string "Web3Dev"
     */
    function questaoC(string memory x) public returns(string memory) {
        respostaC = x;
        return respostaC;
    }

}

