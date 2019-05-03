<?php
function dateFormat($date) {
	$dataHora = explode(" ", $date);
	$data = $dataHora[0];
	$hora = $dataHora[1];
	$data = explode("/", $data);
	$newDate = $data[2]."-".$data[1]."-".$data[0]." ".$hora.":00";
	return $newDate;
}

function dateFormatReverse($date) {
	$newDate = explode('-', $date);
	if (count($newDate) > 0) {
		return $newDate[2]."/".$newDate[0]."/".$newDate[1];
	}
	return $date;
}