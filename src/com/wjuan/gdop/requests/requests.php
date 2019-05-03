<?php
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
	require_once '../util/constants.config.php';
	require_once '../dao/Conexao.class.php';
	require_once '../dao/genericDAO.func.php';
	require_once '../domain/GenericDomain.class.php';
	require_once '../domain/Area.class.php';
	require_once '../domain/Bairro.class.php';
	require_once '../domain/MarcaVeiculo.class.php';
	require_once '../domain/ModeloVeiculo.class.php';
	require_once '../domain/Veiculo.class.php';
	require_once '../services/veiculoService.php';
	require_once '../services/areaService.php';

	$option = trim(strip_tags(filter_input(INPUT_GET, 'option', FILTER_SANITIZE_STRING)));
	$arg = utf8_decode(trim(strip_tags(filter_input(INPUT_GET, 'arg', FILTER_SANITIZE_STRING))));

	if (isset($option)) {
		switch ($option) {
			case 'tiposEnvolvidos':
				die(json_encode(array("status" => "tiposEnvolvidos", "dados" => __TIPO_ENVOLVIDO__)));
				break;
			case 'tiposOcorrencia':
				die(json_encode(array("status" => "tiposOcorrencia", "dados" => __TIPO_OCORRENCIA__)));
				break;
			case 'areas':
				die(json_encode(array("status" => "areas", "dados" => getAreas())));
				break;
			case 'tiposVeiculo':
				die(json_encode(array("status" => "tiposVeiculo", "dados" => __TIPO_VEICULO__)));
				break;
			case 'coresVeiculos':
				die(json_encode(array("status" => "coresVeiculos", "dados" => __CORES_VEICULOS__)));
				break;
			case 'marcas':
				die(json_encode(array("status" => "marcas", "dados" => getMarcasVeiculos($arg))));
				break;
			case 'modelos':
				die(json_encode(array("status" => "modelos", "dados" => getModelosVeiculos($arg))));
				break;
			case 'bairros':
				die(json_encode(array("status" => "bairros", "dados" => getBairros($arg))));
				break;
			case 'veiculos':
				die(json_encode(array("status" => "veiculos", "dados" => getVeiculoPorPlaca($arg))));
				break;
			case 'itensRoubo':
				die(json_encode(array("status" => "itensRoubo", "dados" => __ITENS_ROUBADOS__)));
				break;
			default:
				
				break;
		}
	}
	exit();
}