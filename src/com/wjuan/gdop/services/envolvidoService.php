<?php
/**
 *
 *
 */
function cadastrarEnvolvido($envolvido) {
	try {
		$nascimento = date_format(new DateTime($envolvido->dataNascimento), 'Y-m-d');
		$codEnvolvido = selectFunction(
			"cadastrar_envolvido(
				'".utf8_decode($envolvido->nome)."',
				'$envolvido->cpf',
				'$envolvido->rg',
				'$envolvido->numContato',
				'".utf8_decode($envolvido->endereco)."',
				'$nascimento'
			)"
		);

		if ($codEnvolvido) {
			return $codEnvolvido[0]->value;
		}
		return false;
	} catch (PDOException $e) {
		echo $e->getMessage();
	}
}

/**
 *
 *
 */
function getEnvolvido($codigo) {

}

/**
 *
 *
 */
function getEnvolvidosPeloNome($nome) {
	$envolvidos = callProcedure("SP_get_envolvidos_pelo_nome('$nome')");
	if ($envolvidos) {
		$envolvidosArray = array();
		foreach ($envolvidos as $envolvido) {;
			array_push($envolvidosArray, newEnvolvido($envolvido, null));
		}
		return ($envolvidosArray);
	}
	return false;
}

/**
 *
 *
 */
function newEnvolvido($envolvido, $tipoEnvolvido) {
	$e = new Envolvido(
		$envolvido->codigo,
		$envolvido->nome_envolvido,
		$envolvido->cpf,
		$envolvido->rg,
		$envolvido->num_contato,
		$envolvido->endereco,
		date_format(new DateTime($envolvido->data_nascimento), 'd/m/Y'),
		$tipoEnvolvido
	);
	return $e->serialize();
}