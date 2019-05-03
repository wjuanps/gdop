<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Usuario.class.php';
	require_once '../services/sessionService.php';
	require_once '../services/loginService.php';
	require_once '../util/urlAmigavel.php';

	date_default_timezone_set("America/Belem");

	$usuario = getObjetoNaSessao('usuario');
	if ($usuario) {
		die(json_encode(array("status" => "success", "usuario" => $usuario, "nomeAmigavel" => urlAmigavel($usuario['nome']))));
	} else {
		die(json_encode(array("status" => "erro")));
	}	
	exit;
}