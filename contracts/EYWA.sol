// SPDX-License-Identifier: MIT

// Versão a ser utilizada
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/hardhat/console.sol";

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
        string linkDoExercicio;
        bytes32[] resultados;
    }
    // Mapa que aponta o Score para um endereço
    struct Score {
        uint256 totalScore;
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
    Counters.Counter private totalDeEx;


    // Test ground

    bytes32 public resultadoEsperado;
    bytes public resultadoAluno;
    function getResultadoEsperado() public view returns(bytes32) {
        return resultadoEsperado;
    }
    function getResultadoAluno() public view returns(bytes32) {
        return keccak256(abi.encodePacked(resultadoAluno));
    }


    // Corrige o exercicio
    function corrigirExercicio(uint256 _exercicioId, uint256 _questaoId, address _targetContract, bytes memory _interface) public returns(bool) {
        bytes memory resultadoChamada = _targetContract.functionCall(
            _interface,
            "Error: Erro ao chamar o exercicio :("
        );

        resultadoEsperado = exercicios[_exercicioId].resultados[_questaoId];
        resultadoAluno = resultadoChamada;

        /*require(exercicios[_exercicioId].resultados[_questaoId] == 
                keccak256(abi.encodePacked(resultadoChamada)),
                "Error: Resposta incorreta"
        );*/
        if(score[msg.sender].exerciciosConcluidos[_exercicioId] == false) {
            score[msg.sender].exerciciosConcluidos[_exercicioId] = true;
            score[msg.sender].totalScore +=1;
            emit Correcao(_exercicioId,_questaoId, msg.sender, _targetContract, true);
        }
        // TODO emissoes de eventos
        return true;
    }

    // Dono do contrato insere exercicios
    function inserirExercicio(string memory _linkDoExercicio, bytes32[] calldata _resultados) public dono() {
        totalDeEx.increment();
        uint256 exAtual = totalDeEx.current();

        for(uint256 i = 0; i < _resultados.length; i++){
            exercicios[exAtual].resultados.push(_resultados[i]);
        }
        exercicios[exAtual].linkDoExercicio = _linkDoExercicio;
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