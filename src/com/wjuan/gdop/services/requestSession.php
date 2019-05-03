<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
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
	require_once '../services/sessionService.php';

	date_default_timezone_set("America/Belem");

	$option = trim(strip_tags(filter_input(INPUT_POST, 'option', FILTER_SANITIZE_STRING)));
	$name = trim(strip_tags(filter_input(INPUT_POST, 'name', FILTER_SANITIZE_STRING)));
	$object = json_decode(filter_input(INPUT_POST, 'object'));

	switch ($option) {
		case 'add':
			if (isset($name, $object)) {
				adicionarObjetoNaSessao($name, $object);
			}
			break;
		case 'get':
			$retorno = trim(strip_tags(filter_input(INPUT_POST, 'retorno', FILTER_SANITIZE_STRING)));
			$objetoNaSessao = getObjetoNaSessao($name);
			if ($retorno == 'ocorrencia') {
				$objetoNaSessao = getOcorrencia($objetoNaSessao);
			}
			
			destruirSessao($name);
			die(json_encode($objetoNaSessao));
			break;
		default:
			break;
	}
	
	exit;
}