<?php
/**
 *
 *
 */
function getDatasGeneral($filtro) {
	$y = array(
		'crime'  => 'Tipos de Crimes',
		'area'   => 'Ocorrências por Área',
		'bairro' => 'Ocorrências por Bairro',
		'rua'    => 'Ocorrências por Rua',
		'hora'   => 'Ocorrências por Hora',
		'dia'    => 'Ocorrências por Dia',
		'mes'    => 'Ocorrências por Mês',
		'ano'    => 'Ocorrências por Ano'
	);
	
	$tipos = array("Roubo", "Latrocínio", "Furto");
	if (in_array($filtro->tipo, $tipos)) {
		$y['objeto'] = "Itens Roubados";
	}

	$chartDatas = array();
	foreach ($y as $key => $value) {
		$procedure = "SP_get_datas_chart_".$key."(
			'".utf8_decode($filtro->tipo)."',
			'".utf8_decode($filtro->area)."',
			'".utf8_decode($filtro->bairro)."',
			'".utf8_decode($filtro->rua)."',
			'$filtro->dataInicial',
			'$filtro->dataFinal'
		)";
		$chartValues = callProcedure($procedure);
		if ($chartValues) {
			$label  = $value;
			$backgroundColor      = array();
		    $hoverBackgroundColor = array();
		    $borderColor 		  = array();
			$labels = array();
			$data   = array();
			foreach ($chartValues as $chartValue) {
				array_push($data, (int) $chartValue->total);

				if ($key == 'mes') {
					array_push($labels, __MESES_DO_ANO__[((int) $chartValue->nome) -1]);
				} else if ($key == 'dia') {
					array_push($labels, __DIAS_DA_SEMANA__[((int) $chartValue->nome) - 1]);
				} else {
					array_push($labels, utf8_encode($chartValue->nome));
				}

				$color = getColor();
				array_push($backgroundColor, $color."0.4)");
				array_push($hoverBackgroundColor, $color."0.7)");
				array_push($borderColor, $color."1)");
			}

			if ($key == 'area') {
				array_push($data, (int) array_sum($data));
				array_push($labels, "Castanhal");
				$color = getColor();
				array_push($backgroundColor, $color."0.2)");
				array_push($hoverBackgroundColor, $color."0.5)");
				array_push($borderColor, $color."0.6)");
				$key = "área";
			}

			$key = ($key == "mes") ? $key = "mese" : $key;

			$currentData = array(
				"element" => "morris-bar-chart-".$key,
				"label"   => $label,
				"data" 	  => $data,
				"labels"  => $labels,
				"backgroundColor"      => $backgroundColor,
				"hoverBackgroundColor" => $hoverBackgroundColor,
				"borderColor" 		   => $borderColor
			);

			array_push($chartDatas, $currentData);
		}
	}

	return $chartDatas;
}

function getDatasSeriesTemporal($filtro) {
	$indicesMeses = array();
	foreach (__MESES_DO_ANO__ as $kMes => $vMes) {
	    $indicesMeses[$kMes+1] = 0;
	}

	$dataSets = array();
	$tempDataSet = array();
	foreach (__MESES_DO_ANO__ as $key => $mes) {
	    $kMes = ($key + 1);
		$chartValues = callProcedure("
			SP_get_datas_chart_series_temporal("
				.((int) $kMes).",
				'".utf8_decode($filtro->tipo)."',
				'".utf8_decode($filtro->area)."',
				'".utf8_decode($filtro->bairro)."',
				".((int) $filtro->anoPeriodo)."
			)"
		);
		if ($chartValues) {
			foreach ($chartValues as $chartValue) {
				$valueArray = utf8_encode($chartValue->nome);
				if (!array_key_exists($valueArray, $tempDataSet)) {
					$tempDataSet[$valueArray] = $indicesMeses;
				}
				$tempDataSet[$valueArray] = array_replace_recursive($tempDataSet[$valueArray], array($kMes => (int) $chartValue->total));
			}
		}
	}
	
	foreach ($tempDataSet as $key => $value) {
		$data = array();
		foreach ($value as $vKey => $v) {
			$data[] = $v;
		}
		
		$dataSet = array(
			"label" => $key,
			"borderColor" => getColor()."1)",
			"fill" => false,
			"data" => $data
		);
		array_push($dataSets, $dataSet);
	}

	return array(
		"dataSets" => $dataSets,
		"labels"   => __MESES_DO_ANO__
	);
}

function getColor() {
	return (
		"rgba(".rand(255, 1).", ".rand(255, 1).", ".rand(255, 1).", "
	);
}