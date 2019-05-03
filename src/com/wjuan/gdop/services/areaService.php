<?php
/*
 *
 *
 */
function getAreas() {
	$areas = select("`area`", "*", null, "ORDER BY `area`.`codigo` ASC");
	if ($areas) {
		$arrayAreas = array();
		foreach ($areas as $area) {
			array_push($arrayAreas, utf8_encode($area->nome_area));
		}
		return ($arrayAreas);
	}
	return false;
}

/*
 *
 *
 */
function getBairros($area) {
	$area = ($area == "Castanhal") ? "" : $area;
	$bairros = callProcedure("SP_get_bairros('$area')");
	if ($bairros) {
		$arrayBairros = array();
		foreach ($bairros as $b) {
			$bairro = new Bairro($b->codigo_bairro, $b->nome_bairro, $b->codigo_area, $b->nome_area);
			array_push($arrayBairros, $bairro->serialize());
		}
		return ($arrayBairros);
	}
	return false;
}