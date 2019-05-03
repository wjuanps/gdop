<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/constants.config.php';
	require_once '../dao/Conexao.class.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/MarcaVeiculo.class.php';
	require_once '../domain/ModeloVeiculo.class.php';
	require_once '../domain/Veiculo.class.php';
	require_once '../services/veiculoService.php';

	date_default_timezone_set("America/Belem");

	$filtro = json_decode(filter_input(INPUT_GET, 'filtro'));

	die(json_encode(getVeiculos($filtro)));

	exit;
}