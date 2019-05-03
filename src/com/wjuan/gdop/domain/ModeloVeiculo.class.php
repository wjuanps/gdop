<?php
class ModeloVeiculo extends GenericDomain {

	private $modelo;
    private $marca;
    
    public function ModeloVeiculo($codigoModelo, $modelo, $codigoMarca, $marca, $tipoVeiculo) {
        parent::setCodigo($codigoModelo);
        $this->modelo = utf8_encode($modelo);
        $m = new MarcaVeiculo($codigoMarca, $marca, $tipoVeiculo);
        $this->marca = $m->serialize();
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    public function getModelo() {
        return $this->modelo;
    }

    public function setModelo($modelo) {
        $this->modelo = $modelo;
    } 

    public function getMarcaVeiculo() {
        if ($this->marcaVeiculo == null) {
            $this->marcaVeiculo = new MarcaVeiculo();
        }
        return $this->marcaVeiculo;
    }

    public function setMarcaVeiculo($marcaVeiculo) {
        $this->marcaVeiculo = $marcaVeiculo;
    }
}