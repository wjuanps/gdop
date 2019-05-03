<?php
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
	require_once '../services/sessionService.php';

	destruirSessao();
	die(json_encode(array("sucesso" => (getUsuarioNaSessao() == null))));
	exit;
}