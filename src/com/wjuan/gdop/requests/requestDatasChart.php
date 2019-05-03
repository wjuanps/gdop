<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/constants.config.php';
	require_once '../dao/Conexao.class.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/ItemRoubo.class.php';
	require_once '../domain/Area.class.php';
	require_once '../domain/Bairro.class.php';
	require_once '../domain/Envolvido.class.php';
	require_once '../domain/MarcaVeiculo.class.php';
	require_once '../domain/ModeloVeiculo.class.php';
	require_once '../domain/Veiculo.class.php';
	require_once '../domain/Ocorrencia.class.php';
	require_once '../services/veiculoService.php';
	require_once '../services/envolvidoService.php';
	require_once '../services/ocorrenciaService.php';
	require_once '../services/chartService.php';
	require_once '../util/urlAmigavel.php';
	require_once '../util/functions.php';

	date_default_timezone_set("America/Belem");

	$option = trim(strip_tags(filter_input(INPUT_GET, 'option', FILTER_SANITIZE_STRING)));
	$filtro = json_decode(filter_input(INPUT_GET, 'filtro'));

	switch ($option) {
		case 'serieTemporalCrimes':
			die(json_encode(getDatasSeriesTemporal($filtro)));
			break;

		case 'general':
			die(json_encode(getDatasGeneral($filtro)));	
			break;
			
		default:
			# code...
			break;
	}

	exit;
}