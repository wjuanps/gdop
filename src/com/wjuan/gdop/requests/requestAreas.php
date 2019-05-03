<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/constants.config.php';
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Area.class.php';
	require_once '../domain/Bairro.class.php';
	require_once '../services/areaService.php';

	$option = trim(strip_tags(filter_input(INPUT_GET, 'option', FILTER_SANITIZE_STRING)));
	$area = utf8_decode(trim(strip_tags(filter_input(INPUT_GET, 'area', FILTER_SANITIZE_STRING))));

	switch ($option) {
		case 'areas':
			die(json_encode(getAreas()));
			break;
		case 'bairros':
			die(json_encode(getBairros($area)));
			break;
		default:
			break;
	}
	exit();
}