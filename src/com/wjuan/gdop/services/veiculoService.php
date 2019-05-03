<?php
/*
 *
 *
 */
function cadastrarVeiculo($veiculo) {
	callProcedure("
		SP_cadastrar_veiculo(
			'".$veiculo->placa."',
			'".utf8_decode($veiculo->cor)."',
			'".$veiculo->chassi."',
			".((int) $veiculo->modelo->codigo)."
		)"
	);
	return getVeiculoPorPlaca($veiculo->placa)[0];
}

/*
 *
 *
 */
function getMarcasVeiculos($tipoVeiculo) {
	$marcas = callProcedure("SP_get_marcas_veiculos('".utf8_decode($tipoVeiculo)."')");
	if ($marcas) {
		$marcaArray = array();
		foreach ($marcas as $marca) {
			$m = new MarcaVeiculo($marca->codigo, $marca->marca, $marca->tipo_veiculo);
			array_push($marcaArray, $m->serialize());
		}
		return ($marcaArray);
	}
	return false;
}

/*
 *
 *
 */
function getModelosVeiculos($marca) {
	$modelos = callProcedure("SP_get_modelos_veiculos('$marca')");
	if ($modelos) {
		$modeloArray = array();
		foreach ($modelos as $modelo) {
			$m = new ModeloVeiculo(
				$modelo->codigo,
				$modelo->modelo,
				$modelo->marcaVeiculo_codigo,
				$modelo->marca,
				$modelo->tipo_veiculo
			);
			array_push($modeloArray, $m->serialize());
		}
		return ($modeloArray);
	}
	return false;
}

/*
 *
 *
 */
function getVeiculos($filtro) {
	$veiculos = callProcedure(
		"SP_get_veiculos(
			'".utf8_decode($filtro->tipo)."',
			'".utf8_decode($filtro->marca)."',
			'".utf8_decode($filtro->modelo)."',
			'$filtro->placa'
		)"
	);


	if ($veiculos) {
		$veiculoArray = array();
		foreach ($veiculos as $veiculo) {
			$tempContato = selectFunction("get_contato('$veiculo->codigo')");
			$contato = ($tempContato) ? $tempContato[0]->value : null;
			array_push($veiculoArray, newVeiculo($veiculo, $contato));
		}
	}
	return $veiculoArray;
}

/*
 *
 *
 */
function getVeiculoPorPlaca($placa) {
	$veiculos = callProcedure("SP_get_veiculo_por_placa('$placa')");
	if ($veiculos) {
		$veiculoArray = array();
		foreach ($veiculos as $veiculo) {
			array_push($veiculoArray, newVeiculo($veiculo, null));
		}
		return ($veiculoArray);
	}
	return false;
}

/*
 *
 *
 */
function newVeiculo($veiculo, $contato) {
	$v = new Veiculo(
		$veiculo->codigo,
		$veiculo->placa,
		$veiculo->chassi, 
		$veiculo->cor,
		$veiculo->modelo_codigo,
		$veiculo->modelo, 
		$veiculo->marca_codigo,
		$veiculo->marca,
		$veiculo->tipo_veiculo
	);
	if (!is_null($contato)) {
		$v->setNumProprietario($contato);
	}
	return $v->serialize();
}