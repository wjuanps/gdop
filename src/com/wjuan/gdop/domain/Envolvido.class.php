<?php
class Envolvido extends GenericDomain {

    private $nome;
    private $cpf;
    private $rg;
    private $numContato;
    private $endereco;
    private $dataNascimento;

    private $tipoEnvolvido;
    
    private $ocorrencias = array();

    public function Envolvido($codigo, $nome, $cpf, $rg, $numContato, $endereco, $dataNascimento, $tipoEnvolvido) {
        parent::setCodigo($codigo);
        $this->nome = utf8_encode($nome);
        $this->cpf = $cpf;
        $this->rg = $rg;
        $this->numContato = $numContato;
        $this->endereco = utf8_encode($endereco);
        $this->dataNascimento = $dataNascimento;
        $this->tipoEnvolvido = utf8_encode($tipoEnvolvido);
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    public function getNome() {
        return $this->nome;
    }

    public function setNome($nome) {
        $this->nome = $nome;
    }

    public function getCpf() {
        return $cpf;
    }

    public function setCpf($cpf) {
        $this->cpf = $cpf;
    }

    public function getRg() {
        return $rg;
    }

    public function setRg($rg) {
        $this->rg = $rg;
    }

    public function getNumContato() {
        return $numContato;
    }

    public function setNumContato($numContato) {
        $this->numContato = $numContato;
    }

    public function getEndereco() {
        return $this->endereco;
    }

    public function setEndereco($endereco) {
        $this->endereco = $endereco;
    }

    public function getTipoEnvolvido() {
        return $this->tipoEnvolvido;
    }

    public function setTipoEnvolvido($tipoEnvolvido) {
        $this->tipoEnvolvido = $tipoEnvolvido;
    }

    public function getDataNascimento() {
        return $dataNascimento;
    }

    public function setDataNascimento($dataNascimento) {
        $this->dataNascimento = $dataNascimento;
    }

    public function getOcorrencias() {
        return $ocorrencias;
    }

    public function addOcorrencia($ocorrencia) {
    	array_push($ocorrencias, $ocorrencia);
    }

}