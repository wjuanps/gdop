<?php
function cadastrarUsuario($usuario) {
	$usuarioCodigo = selectFunction(
		"cadastrar_usuario(
			'".utf8_decode($usuario->nome)."',
			'".utf8_decode($usuario->email)."',
			'".utf8_decode($usuario->postoOuGraduacao)."',
			'$usuario->rgMilitar',
			'".utf8_decode($usuario->senha)."',
			'".utf8_decode($usuario->tipo)."'
		)"
	);
	if ($usuarioCodigo) {
		return $usuarioCodigo;
	}
	return false;
}

function atualizarCadastroUsuario($usuario) {
	$atualizar = selectFunction(
		"atualizar_usuario(
			".$usuario->codigo.",
			'".utf8_decode($usuario->nome)."',
			'".utf8_decode($usuario->email)."',
			'".utf8_decode($usuario->postoOuGraduacao)."',
			'$usuario->rgMilitar',
			'".utf8_decode($usuario->tipo)."',
			'".utf8_decode($usuario->senha)."'
		)"
	);
	
	if ($atualizar) {
		return true;
	}
	return false;
}

function getUsuario($rgMilitar) {
	$tempUsuario = select("`usuario`", "*", "WHERE `usuario`.`rg_militar` = ".$rgMilitar);
	if ($tempUsuario) {
		foreach ($tempUsuario as $u) {
			$usuario = new Usuario($u->codigo, $u->rg_militar, $u->posto_ou_graduacao, $u->nome_usuario, $u->tipo, $u->email, $u->senha);
		}
		return $usuario->serialize();
	}
	return false;
}

function isEmailCadastrado($email) {
	$isUsuario = select("`usuario`", "*", "WHERE `usuario`.`email` = '$email'");
	if ($isUsuario) {
		return true;
	}
	return false;
}

function isRGMilitarCadastrado($rgMilitar) {
	$isRGMilitarCadastrado = select("`usuario`", "*", "WHERE `usuario`.`rg_militar` = '$rgMilitar'");
	if ($isRGMilitarCadastrado) {
		return true;
	}
	return false;
}