<?php
class MarcaVeiculo extends GenericDomain {

    private $marca;
    private $tipo;

    public function MarcaVeiculo($codigo, $marca, $tipoVeiculo) {
        parent::setCodigo($codigo);
        $this->marca = utf8_encode($marca);
        $this->tipo  = utf8_encode($tipoVeiculo);
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    public function getMarca() {
        return $this->marca;
    }

    public function setMarca($marca) {
        $this->marca = $marca;
    }

    public function getModeloVeiculos() {
        return $this->modeloVeiculos;
    }

    public function getTipoVeiculo() {
        return $this->tipoVeiculo;
    }

    public function setTipoVeiculo($tipoVeiculo) {
        $this->tipoVeiculo = $tipoVeiculo;
    }
}