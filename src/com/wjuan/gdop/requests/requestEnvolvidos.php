<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/constants.config.php';
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Envolvido.class.php';
	require_once '../services/envolvidoService.php';
	require_once '../util/functions.php';

	$nome = utf8_decode(trim(strip_tags(filter_input(INPUT_GET, 'nome', FILTER_SANITIZE_STRING))));

	$envolvidos = getEnvolvidosPeloNome($nome);
	die(json_encode($envolvidos));
	exit();
}