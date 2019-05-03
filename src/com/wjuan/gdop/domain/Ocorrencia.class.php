<?php
class Ocorrencia extends GenericDomain {

	private $tipo;
    private $rua;
    private $dataHora;

    private $envolvidos   = array();
    private $veiculos     = array();
    private $itensRoubo   = array();
    
    private $descricao;
    private $informacoesComplementares;
    private $trote;

    private $bairro;

    public function Ocorrencia($codigo, $tipo, $rua, $dataHora, $descricao, $informacoesComplementares, $trote,
                                $bairro_codigo, $nome_bairro, $area_codigo, $nome_area) {
        parent::setCodigo($codigo);
        $this->tipo = utf8_encode($tipo);
        $this->rua = utf8_encode($rua);
        $this->dataHora = $dataHora;
        $this->descricao = utf8_encode($descricao);
        $this->informacoesComplementares = utf8_encode($informacoesComplementares);
        $this->trote = $trote;
        $b = new Bairro(
            $bairro_codigo,
            $nome_bairro,
            $area_codigo, 
            $nome_area
        );
        $this->bairro = $b->serialize();
    }

    public function serialize() {
        return array_merge(parent::serialize(), get_object_vars($this));
    }

    /**
     * 
     * @param envolvido 
     * @param tipoEnvolvido 
     */
    public function addEnvolvido($envolvido, $tipoEnvolvido) {
        $oce = new OCorrenciaEnvolvido($this, $envolvido);
        $oce->setTipoEnvolvido($tipoEnvolvido);
        array_push($envolvidos, $oce);
        array_push($envolvido->getEnvolvidos(), $oce);
    }
    
    /**
     * 
     * @param veiculo 
     */
    public function addVeiculo($veiculo) {
        $ov = new OcorrenciaVeiculo($this, $veiculo);
        array_push($this->veiculos, $ov);
        array_push($veiculo->getOcorrencias, $ov);
    }
    
    public function getTipo() {
        if (is_null($this->tipo)) {
            $this->tipo = "Tipo/Roubo/Furto";
        }
        return $this->tipo;
    }

    public function setTipo($tipo) {
        $this->tipo = $tipo;
    }

    public function getRua() {
        return $this->rua;
    }

    public function setRua($rua) {
        $this->rua = $rua;
    }

    public function getDataHora() {
        return $this->dataHora;
    }

    public function setDataHora($dataHora) {
        $this->dataHora = $dataHora;
    }

    public function getDescricao() {
        return $this->descricao;
    }

    public function setDescricao($descricao) {
        $this->descricao = $descricao;
    }

    public function getInformacoesComplementares() {
        return $this->informacoesComplementares;
    }

    public function setInformacoesComplementares($informacoesComplementares) {
        $this->informacoesComplementares = $informacoesComplementares;
    }

    function setTrote($trote) {
        $this->trote = $trote;
    }

    function isTrote() {
        return $this->trote;
    }

    public function getEnvolvidos() {
        return $this->envolvidos;
    }

    public function getVeiculos() {
        return $this->veiculos;
    }

    public function getItensRoubo() {
        return $this->itensRoubo;
    }

    public function getBairro() {
        if (is_null($this->bairro)) {
            $this->bairro = new Bairro();
        }
        return $this->bairro;
    }

    public function setBairro($bairro) {
        $this->bairro = $bairro;
    }
}