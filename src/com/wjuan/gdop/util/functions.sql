tipo area bairro rua dataInicial dataFinal

BEGIN
	
	DECLARE codigo_ocorrencia BIGINT(20) DEFAULT 0;

	INSERT INTO 
		`ocorrencia` (
			`tipo`, `rua`, `data_hora`, `descricao`, 
			`info_complementares`, `is_trote`, `bairro_codigo`
		) 
	VALUES (
		tipo, rua, TIMESTAMP(dataHora), descricao, 
		info_complementares, trote, bairro
	);

	SELECT 
	    MAX(`codigo`)
	FROM
	    `ocorrencia` INTO codigo_ocorrencia;

	IF (codigo_ocorrencia <> 0) THEN
		RETURN codigo_ocorrencia;
	END IF;

	RETURN FALSE;
END

	UPDATE 
		`ocorrencia` 
	SET
		`ocorrencia`.`tipo` = tipo,
		`ocorrencia`.`rua`  = rua,
		`ocorrencia`.`data_hora` = dataHora,
		`ocorrencia`.`descricao` = descricao,
		`ocorrencia`.`info_complementares` = infoComplementares,
		`ocorrencia`.`is_trote` = isTrote,
		`ocorrencia`.`bairro_codigo` = bairroCodigo
	WHERE
		`ocorrencia`.`codigo` = codigo;
