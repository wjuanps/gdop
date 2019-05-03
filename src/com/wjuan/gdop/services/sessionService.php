<?php
session_start();

function adicionarObjetoNaSessao($name, $object) {
	$_SESSION[$name] = $object;
}

function getObjetoNaSessao($name) {
	return (isset($_SESSION[$name])) ? $_SESSION[$name] : null;
}

function destruirSessao($name) {
	if (isset($_SESSION[$name])) {
		unset($_SESSION[$name]);
	}
}