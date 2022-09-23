// SPDX-License-Identifier: MIT

// Versão a ser utilizada no compilador (hardhat.config.js)
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/// @title  Contrato Prova
/// @author Exis
/// @dev    Usando function call, um contrato mestre de correcao
//          pode ser invocado para corrigir um contrato. Basta
//          encodar os argumentos da interface com os parametros
//          e inserir como parametro na function call. Ver EYWA.sol

contract EYWA {
    using Address for address;
    using Counters for Counters.Counter;

    modifier dono() {
        require(msg.sender == owner,"Error: Precisa ser o dono");
        _;
    }

    // Emissao da correcao
    event Correcao(
        uint256 indexed exercicio,
        uint256 indexed _questaoId,
        address indexed estudante,
        address contrato,
        bool resultado        
    );
    
    // Mapa de ID do exercício apontando para seu Link
    struct Exercicios {
        string linkDoEnunciado;
        bytes[] resultados;
    }
    // Mapa que aponta o Score para um endereço
    struct Score {
        uint256 totalDeExerciciosConcluidos;
        mapping(uint256 => bool) exerciciosConcluidos;
        mapping(uint256 => uint256) gasUsado;
    }

    // Dono do contrato
    address immutable owner;
    constructor(address _owner) {
        owner = _owner;
    }

    mapping (uint256 => Exercicios) public exercicios;
    mapping (address => Score) public score;
    Counters.Counter private totalDeExercicios;

    // Corrige o exercicio
    function corrigirExercicio(
        uint256 _exercicioId, 
        uint256 _questaoId, 
        address _targetContract, 
        bytes memory _interface
    ) public returns(bool) {
        bytes memory resultadoChamada = _targetContract.functionCall( 
            _interface,
            "Error: Erro ao chamar o exercicio :("
        );

        require(keccak256(exercicios[_exercicioId].resultados[_questaoId]) == 
                keccak256(resultadoChamada),
                "Error: Resposta incorreta"
        );
        if(score[msg.sender].exerciciosConcluidos[_exercicioId] == false) {
            score[msg.sender].exerciciosConcluidos[_exercicioId] = true;
            score[msg.sender].totalDeExerciciosConcluidos +=1;
            emit Correcao(_exercicioId,_questaoId, msg.sender, _targetContract, true);
        }
        return true;
    }

    // Dono do contrato insere exercicios
    function inserirExercicio(string memory _linkDoExercicio, bytes[] calldata _resultados) public dono() {
        totalDeExercicios.increment();
        uint256 exercicioAtual = totalDeExercicios.current();

        for(uint256 i = 0; i < _resultados.length; i++){
            exercicios[exercicioAtual].resultados.push(_resultados[i]);
        }
        exercicios[exercicioAtual].linkDoEnunciado = _linkDoExercicio;
        // TODO emissoes de eventos
    }

    // Atualiza o score do aluno quanto ao uso de gasolina
    function atualizaUsoDeGasolina(uint256 _exercicio, address _estudante, uint256 _gasUsado) public dono() {
        require(
            score[_estudante].exerciciosConcluidos[_exercicio] == true,
            "Error: Exercicio precisa ter sido concluido."
        );
        if(score[_estudante].gasUsado[_exercicio] > _gasUsado) {
            score[_estudante].gasUsado[_exercicio] = _gasUsado;
        }
        // TODO emissoes de eventos
    }

}