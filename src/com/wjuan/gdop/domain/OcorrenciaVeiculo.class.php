<?php
class OcorrenciaVeiculo {

	private $ocorrencia;
    private $veiculo;

    public OcorrenciaVeiculo($ocorrencia, $veiculo) {
        $this->ocorrencia = $ocorrencia;
        $this->veiculo    = $veiculo;
    }

    public function getOcorrencia() {
        return $this->ocorrencia;
    }

    public function setOcorrencia($ocorrencia) {
        $this->ocorrencia = $ocorrencia;
    }

    public function getVeiculo() {
        return $veiculo;
    }

    public function setVeiculo($veiculo) {
        $this->veiculo = $veiculo;
    }
}