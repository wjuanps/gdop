<?php
class Veiculo extends GenericDomain {

	private $modelo;
    private $placa;
    private $chassi;
    private $cor;

    private $numProprietario;

    private $ocorrencias = array();
    
    public function Veiculo($codigo, $placa, $chassi, $cor, $codigoModelo, $modelo, $codigoMarca, $marca, $tipoVeiculo) {
        parent::setCodigo($codigo);
        $this->placa = $placa;
        $this->chassi = $chassi;
        $this->cor = utf8_encode($cor);
        $m = new ModeloVeiculo($codigoModelo, $modelo, $codigoMarca, $marca, $tipoVeiculo);
        $this->modelo = $m->serialize();
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    public function getModeloVeiculo() {
        return $this->modeloVeiculo;
    }

    public function setModeloVeiculo($modeloVeiculo) {
        $this->modeloVeiculo = $modeloVeiculo;
    }

    public function getPlaca() {
        return $this->placa;
    }

    public function setPlaca($placa) {
        $this->placa = $placa;
    }

    public function getChassi() {
        return $this->chassi;
    }

    public function setChassi($chassi) {
        $this->chassi = $chassi;
    }

    public function getOcorrencias() {
        return $this->ocorrencias;
    }

    public function getCor() {
        return $this->cor;
    }

    public function setCor($cor) {
        $this->cor = $cor;
    }

    public function getNumProprietario() {
        return $this->numProprietario;
    }

    public function setNumProprietario($numProprietario) {
        $this->numProprietario = $numProprietario;
    }
}