<?php
class Bairro extends GenericDomain {

	private $nome;
	private $area;

	public function Bairro($codigo_bairro, $nome_bairro, $codigo_area, $nome_area) {
		parent::setCodigo($codigo_bairro);
		$this->nome = utf8_encode($nome_bairro);
		$a = new Area($codigo_area, $nome_area);
		$this->area = $a->serialize();
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

	public function getArea() {
		return $this->area;
	}

	public function setArea($area) {
		$this->area = $area;
	}

}