<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Usuario.class.php';
	require_once '../services/cadastroUsuarioService.php';
	require_once '../services/sessionService.php';
	require_once '../services/loginService.php';

	$option = trim(strip_tags(filter_input(INPUT_POST, 'option', FILTER_SANITIZE_STRING)));
	$arg    = trim(strip_tags(filter_input(INPUT_POST, 'arg', FILTER_SANITIZE_STRING)));

	switch ($option) {
		case 'checkEmail':
			$isEmail = isEmailCadastrado($arg);
			die(json_encode(array("status" => ($isEmail) ? "existeEmail" : "naoExisteEmail")));
			break;
		case 'checkRGMilitar':
			$isRGMilitar = isRGMilitarCadastrado((int) $arg);
			die(json_encode(array("status" => ($isRGMilitar) ? "existeRGMilitar" : "naoExisteRGMilitar")));
			break;
		case 'cadastrarAtualizar':
			$usuario = json_decode(filter_input(INPUT_POST, 'usuario'));
			if ($arg == "cadastrar") {
				$msg = (isEmailCadastrado($usuario->email)) ? "email" : (isRGMilitarCadastrado($usuario->rgMilitar)) ? "rgMilitar" : null;
				if (is_null($msg)) {
					$response = cadastrarUsuario($usuario);
				} else {
					die(json_encode(array("status" => $msg)));
				}
			} else {
				$response = atualizarCadastroUsuario($usuario);
				if ($response) {
					$novoUsuario = getUsuario($usuario->rgMilitar);
					if ($novoUsuario) {
						adicionarObjetoNaSessao('usuario', $novoUsuario);
					}
				}
			}
			die(json_encode(array("status" => ($response) ? "success" : "Erro ao cadastrar usuário")));
			break;
		default:
			break;
	}
	
}