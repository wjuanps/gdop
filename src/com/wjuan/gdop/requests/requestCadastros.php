<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Envolvido.class.php';
	require_once '../domain/Bairro.class.php';
	require_once '../domain/MarcaVeiculo.class.php';
	require_once '../domain/ModeloVeiculo.class.php';
	require_once '../domain/Veiculo.class.php';
	require_once '../services/veiculoService.php';
	require_once '../services/envolvidoService.php';
	require_once '../services/ocorrenciaService.php';

	$option = trim(strip_tags(filter_input(INPUT_POST, 'option', FILTER_SANITIZE_STRING)));
	$object = json_decode(filter_input(INPUT_POST, 'object'));

	switch ($option) {
		case 'veiculo':
			die(json_encode(cadastrarVeiculo($object)));
			break;
		case 'envolvido':
			//die(cadastrarEnvolvido($object));
			die(json_encode(10));
			break;
		case 'ocorrencia':
			$arg = trim(strip_tags(filter_input(INPUT_POST, 'arg', FILTER_SANITIZE_STRING)));
			die(($arg == 'cadastrar') ? cadastrarOcorrencia($object) : atualizarOcorrencia($object));
			break;
		default:
			break;
	}
	exit();
}