// SPDX-License-Identifier: UNLICENSED

// Versão a ser utilizada
pragma solidity ^0.8.9;


/// @title  Contrato Prova
/// @author Exis
/// @dev    Contrato modelo de prova com múltiplos exercícios.
//          O objetivo é incentivar o uso de interface e retornos
//          encriptados, para validar se o estudante sabe construir
//          funcoes e processos


interface IExercicio {
    function questaoA(uint256) external returns(bytes32);
    function questaoB(uint256, uint256) external returns(bytes32);
    function questaoC(string memory) external returns(bytes32);
}

contract Exercicio1 is IExercicio{

    uint256 public respostaA; // 20
    uint256 public respostaB; // 100
    string public respostaC; // "Web3Dev"

    /**
     *  @dev Recebe X e soma 5. Retornando o sha3 do valor 20 para a variavel respostaA
     */
    function questaoA(uint256 x) public returns(bytes32) {
        respostaA = x+5;
        return keccak256(abi.encodePacked(respostaA));
    }

    /**
     *  @dev Precisa retornar o sha3 do valor 100 para a variavel respostaA
     */
    function questaoB(uint256 x, uint256 y) public returns(bytes32) {
        respostaB = x+y;
        return keccak256(abi.encodePacked(respostaB));
    }

    /**
     *  @dev Precisa retornar o keccak256 da string "Web3Dev"
     */
    function questaoC(string memory x) public returns(bytes32) {
        respostaC = x;
        return keccak256(abi.encodePacked(respostaC));
    }

}

