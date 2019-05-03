<?php
function logarNoSistema($rgMilitar, $senha) {
	try {
		$tempUsuario = callProcedure("SP_acessar_sistema('$rgMilitar', '$senha')");
		if ($tempUsuario) {
			foreach ($tempUsuario as $u) {
				$usuario = new Usuario($u->codigo, $u->rg_militar, $u->posto_ou_graduacao, $u->nome_usuario, $u->tipo, $u->email, $u->senha);
			}
			return $usuario->serialize();
		}
		return false;
	} catch (PDOException $e) {
		$e->getMessage();
		return false;
	}
}