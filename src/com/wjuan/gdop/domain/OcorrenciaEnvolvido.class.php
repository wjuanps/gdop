<?php
class OcorrenciaEnvolvido {

    private $ocorrencia;
    private $envolvido;

    private $tipoEnvolvido;

    public OcorrenciaEnvolvido($ocorrencia, $envolvido) {
        $this->ocorrencia = $ocorrencia;
        $this->envolvido  = $envolvido;
    }

    public function getOcorrencia() {
        return $this->ocorrencia;
    }

    public function setOcorrencia($ocorrencia) {
        $this->ocorrencia = $ocorrencia;
    }

    public function getEnvolvido() {
        return $this->envolvido;
    }

    public function setEnvolvido($envolvido) {
        $this->envolvido = $envolvido;
    }

    public function getTipoEnvolvido() {
        return $this->tipoEnvolvido;
    }

    public function setTipoEnvolvido($tipoEnvolvido) {
        $this->tipoEnvolvido = $tipoEnvolvido;
    }
}