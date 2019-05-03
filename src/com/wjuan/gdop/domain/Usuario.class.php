<?php
final class Usuario extends GenericDomain {
	
	private $rgMilitar;
	private $postoOuGraduacao;

	private $nome;
	private $tipo;
	private $email;
	private $senha;

	public function Usuario($codigo, $rgMilitar, $postoOuGraduacao, $nome, $tipo, $email, $senha) {
		parent::setCodigo($codigo);
		$this->rgMilitar = $rgMilitar;
		$this->postoOuGraduacao = utf8_encode($postoOuGraduacao);
		$this->nome = utf8_encode($nome);
		$this->tipo = utf8_encode($tipo);
		$this->email = $email;
		$this->senha = $senha;
	}

	public function serialize() {
		return array_merge(parent::serialize(), get_object_vars($this));
	}

	public function getRgMilitar() {
		return $this->rgMilitar;
	}

	public function setRgMilitar($rgMilitar) {
		$this->rgMilitar = $rgMilitar;
	}

	public function getPostoOuGraduacao() {
		return $this->postoOuGraduacao;
	}

	public function setPostoOuGraduacao($postoOuGraduacao) {
		$this->postoOuGraduacao = $postoOuGraduacao;
	}

	public function getNome() {
		return $this->nome;
	}

	public function setNome($nome) {
		$this->nome = $nome;
	}

	public function getEmail() {
		return $this->email;
	}

	public function setEmail($email) {
		$this->email = $email;
	}

	public function getSenha() {
		return $this->senha;
	}

	public function setSenha($senha) {
		return $this->senha = $senha;
	}	
}