<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Usuario.class.php';
	require_once '../services/sessionService.php';
	require_once '../services/loginService.php';

	date_default_timezone_set("America/Belem");

	$option = trim(strip_tags(filter_input(INPUT_POST, 'option', FILTER_SANITIZE_STRING)));

	switch ($option) {
		case 'login':
			$rgMilitar = (int) trim(strip_tags(filter_input(INPUT_POST, 'rgMilitar', FILTER_SANITIZE_STRING)));
			$senha	   = trim(strip_tags(filter_input(INPUT_POST, 'senha', FILTER_SANITIZE_STRING)));

			if (isset($rgMilitar, $senha)) {				
				$usuario = logarNoSistema($rgMilitar, $senha);
				if ($usuario) {
					adicionarObjetoNaSessao('usuario', $usuario);
					die(json_encode(array("status" => "success")));
				} else {
					die(json_encode(array("status" => "erro")));
				}
				exit;
			}
			break;
		case 'logout':
			destruirSessao('usuario');
			break;
		default:
			# code...
			break;
	}
}