<?php
class Area extends GenericDomain {

	private $nome;

	public function Area($codigo, $nome) {
		parent::setCodigo($codigo);
		$this->nome = utf8_encode($nome);
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

	public function getBairros() {
		return $this->bairros;
	}

	public function addBairro($bairro) {
		array_push($bairros, $bairro);
	}

}