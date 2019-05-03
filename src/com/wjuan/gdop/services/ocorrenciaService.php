<?php

/**
 *
 *
 */
function getOcorrencias($filtro) {
	$ocorrencias = callProcedure("
		SP_get_ocorrencias(
			'".utf8_decode($filtro->tipo)."',
			'".utf8_decode($filtro->area)."',
			'".utf8_decode($filtro->bairro)."',
			'".utf8_decode($filtro->rua)."',
			'$filtro->dataInicial',
			'$filtro->dataFinal'
		)
	");

	if ($ocorrencias) {
		$arrayOcorrencias = array();
		foreach ($ocorrencias as $o) {
			array_push($arrayOcorrencias, newOcorrencia($o));
		}
		return ($arrayOcorrencias);
	}
	return false;
}

/**
 *
 *
 */
function getOcorrencia($codigo) {
	try {
		$tempOcorrencia = callProcedure("
			SP_get_ocorrencia($codigo)
		");
		if ($tempOcorrencia) {
			$ocorrencia = newOcorrencia($tempOcorrencia[0]);
			$envolvidos = callProcedure("SP_get_ocorrencia_envolvidos($codigo)");
			if ($envolvidos) {
				foreach ($envolvidos as $e) {
					$envolvido = newEnvolvido($e, $e->tipo_envolvido);
					array_push($ocorrencia['envolvidos'], $envolvido);
				}
			}

			$veiculos = callProcedure("SP_get_ocorrencia_veiculos($codigo)");
			if ($veiculos) {
				foreach ($veiculos as $veiculo) {
					array_push($ocorrencia['veiculos'], newVeiculo($veiculo, null));
				}
			}

			$itensRoubo = callProcedure("SP_get_ocorrencia_itens_roubo($codigo)");
			if ($itensRoubo) {
				foreach ($itensRoubo as $ir) {
					$itemRoubo = new ItemRoubo($ir->codigo, $ir->item, $ir->quantidade);
					array_push($ocorrencia['itensRoubo'], $itemRoubo->serialize());
				}
			}

			return $ocorrencia;
		}
	} catch (PDOException $e) {
		return $e->getMessage();
	}
	return false;
}

function cadastrarOcorrencia($ocorrencia) {
	$codigo = 0;
	try {
		$bairro = select("`bairro`", "`bairro`.`codigo` AS codigo", "WHERE `bairro`.`nome_bairro` = '$ocorrencia->bairro'", null, "LIMIT 1");
		$tempOcorrencia = selectFunction("
			cadastrar_ocorrencia(
				'".utf8_decode($ocorrencia->tipo)."',
				'".utf8_decode($ocorrencia->rua)."',
				'$ocorrencia->dataHora',
				'".utf8_decode($ocorrencia->descricao)."',
				'".utf8_decode($ocorrencia->informacoesComplementares)."',
				".((int)  $bairro[0]->codigo).",
				".((int) $ocorrencia->trote)."
			)
		");
		if ($tempOcorrencia) {
			$codigo = $tempOcorrencia[0]->value;
			cadastrarDadosRelacionadosOcorrencia($ocorrencia, $codigo);
		}
	} catch (PDOException $e) {
		return $e->getMessage();
	}
	return $codigo;
}

function atualizarOcorrencia($ocorrencia) {
	$codigo = 0;
	try {
		$bairro = select("`bairro`", "`bairro`.`codigo` AS codigo", "WHERE `bairro`.`nome_bairro` = '$ocorrencia->bairro'", null, "LIMIT 1");
		$ocorrenciaCodigo = selectFunction("
			atualizar_ocorrencia(
				".((int)  $ocorrencia->codigo).",
				'".utf8_decode($ocorrencia->tipo)."',
				'".utf8_decode($ocorrencia->rua)."',
				'$ocorrencia->dataHora',
				'".utf8_decode($ocorrencia->descricao)."',
				'".utf8_decode($ocorrencia->informacoesComplementares)."',
				".(intval($ocorrencia->trote)).",
				".(intval($bairro[0]->codigo))."
			)
		");
		if ($ocorrenciaCodigo) {
			$codigo = $ocorrenciaCodigo[0]->value;
			cadastrarDadosRelacionadosOcorrencia($ocorrencia, $codigo);
		}
	} catch (PDOException $e) {
		return $e->getMessage();
	}
	return $codigo;
}

function cadastrarDadosRelacionadosOcorrencia($ocorrencia, $codigo) {
	foreach ($ocorrencia->envolvidos as $envolvido) {
		cadastrarOcorrenciaEnvolvido($envolvido, $codigo);
	}

	if (!empty($ocorrencia->veiculos)) {
		foreach ($ocorrencia->veiculos as $veiculo) {
			cadastrarOcorrenciaVeiculo($veiculo, $codigo);
		}
	}

	if (!empty($ocorrencia->itensRoubo)) {
		foreach ($ocorrencia->itensRoubo as $itemRoubado) {
			cadastrarOcorrenciaItemRoubo($itemRoubado, $codigo);
		}
	}
}

function cadastrarOcorrenciaEnvolvido($envolvido, $codigo) {
	callProcedure("
		SP_cadastrar_ocorrencia_envolvido(
			".$codigo.",
			".$envolvido->codigo.",
			'".utf8_decode($envolvido->tipoEnvolvido)."'
		)
	");
}

function cadastrarOcorrenciaVeiculo($veiculo, $codigo) {
	callProcedure("
		SP_cadastrar_ocorrencia_veiculo(
			".$codigo.",
			".$veiculo->codigo."
		)
	");	
}

function cadastrarOcorrenciaItemRoubo($itemRoubo, $codigo) {
	callProcedure(
		"SP_cadastrar_ocorrencia_item_roubo(
			".$codigo.",
			'".utf8_decode($itemRoubo->item)."',
			".((int) $itemRoubo->quantidade)."
		)"
	);	
}

function newOcorrencia($o) {
	$o->data_hora = date_format(new DateTime($o->data_hora), 'd/m/Y H:i');
	$ocorrencia = new Ocorrencia(
		$o->codigo, 
		$o->tipo,
		$o->rua,
		$o->data_hora,
		$o->descricao,
		$o->info_complementares,
		$o->is_trote,
		$o->bairro_codigo,
		$o->nome_bairro,
		$o->area_codigo,
		$o->nome_area
	);
	$ocorrencia->setTrote(boolval($o->is_trote));
	return $ocorrencia->serialize();
}