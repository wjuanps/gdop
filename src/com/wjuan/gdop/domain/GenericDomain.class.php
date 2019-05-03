<?php
class GenericDomain {

	private $codigo;

	public function serialize() {
		return get_object_vars($this);
	}

	function getCodigo() {
		return $this->codigo;
	}

	function setCodigo($codigo) {
		$this->codigo = $codigo;
	}

}