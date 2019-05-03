-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 05, 2018 at 06:19 PM
-- Server version: 10.1.28-MariaDB
-- PHP Version: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_gdop`
--
CREATE DATABASE IF NOT EXISTS `db_gdop` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `db_gdop`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `SP_acessar_sistema`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_acessar_sistema` (IN `rgMilitar` VARCHAR(10) CHARSET utf8, IN `senha` VARCHAR(100) CHARSET utf8)  NO SQL
SELECT
	*
FROM
	`usuario`
WHERE
	`usuario`.`rg_militar` = rgMilitar AND
    `usuario`.`senha` = MD5(senha)$$

DROP PROCEDURE IF EXISTS `SP_cadastrar_ocorrencia_envolvido`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_cadastrar_ocorrencia_envolvido` (`ocorrencia` BIGINT(20), `envolvido` BIGINT(20), `tipo` VARCHAR(255))  BEGIN
	INSERT INTO `ocorrencia_has_envolvido` (
		`ocorrencia_codigo`, `envolvido_codigo`, `envolvido`
    )
    VALUES (
    	ocorrencia, envolvido, tipo
    );
END$$

DROP PROCEDURE IF EXISTS `SP_cadastrar_ocorrencia_item_roubo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_cadastrar_ocorrencia_item_roubo` (IN `ocorrencia_codigo` BIGINT(20), IN `item` VARCHAR(100) CHARSET utf8, IN `quantidade` INT(11))  NO SQL
BEGIN
	INSERT INTO `item_roubo` (
		`ocorrencia_codigo`, `item`, `quantidade`
	) VALUES (
		ocorrencia_codigo, item, quantidade
	);
END$$

DROP PROCEDURE IF EXISTS `SP_cadastrar_ocorrencia_veiculo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_cadastrar_ocorrencia_veiculo` (`ocorrencia` BIGINT(20), `veiculo` BIGINT(20))  BEGIN
	INSERT INTO `ocorrencia_has_veiculo` (
		`ocorrencia_codigo`, `veiculo_codigo`
    )
    VALUES (
    	ocorrencia, veiculo
    );
END$$

DROP PROCEDURE IF EXISTS `SP_cadastrar_veiculo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_cadastrar_veiculo` (IN `placa` VARCHAR(10) CHARSET utf8, IN `cor_veiculo` VARCHAR(50) CHARSET utf8, IN `chassi` VARCHAR(50) CHARSET utf8, IN `modelo_codigo` BIGINT(20))  NO SQL
BEGIN
    INSERT INTO `veiculo` (
        `placa`, `cor_veiculo`, `chassi`, `modeloVeiculo_codigo`
    ) VALUES (
        UPPER(placa), cor_veiculo, UPPER(chassi), modelo_codigo
    );
END$$

DROP PROCEDURE IF EXISTS `SP_get_bairros`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_bairros` (IN `area` VARCHAR(45) CHARSET utf8)  BEGIN
	SELECT 
    	`bairro`.`codigo` AS `codigo_bairro`,
        `bairro`.`nome_bairro`,
        `area`.`codigo` AS `codigo_area`,
        `area`.`nome_area`
    FROM 
    	`bairro`
    INNER JOIN 
    	`area` 
	ON (
        `bairro`.`area_codigo` = `area`.`codigo`
    )
    WHERE
    	LOWER(`area`.`nome_area`) LIKE CONCAT('%', LOWER(area), '%');
    
END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_ano`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_ano` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20) CHARSET utf8, IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
		SELECT
			YEAR(`ocorrencia`.`data_hora`) AS nome, 
            COUNT(YEAR(`ocorrencia`.`data_hora`)) AS total
		FROM 
			`ocorrencia`
		INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
	    GROUP BY 
        	YEAR(`ocorrencia`.`data_hora`) 
        ORDER BY 
        	total DESC 
        LIMIT 3;
	END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_area`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_area` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
	SELECT 
        `area`.`nome_area` AS nome, COUNT(`area`.`nome_area`) AS total 
    FROM 
        `ocorrencia` 
    INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
    GROUP BY 
        `area`.`nome_area`;
END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_bairro`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_bairro` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
	SELECT 
        `bairro`.`nome_bairro` AS nome, COUNT(`bairro`.`nome_bairro`) AS total 
    FROM 
        `ocorrencia` 
    INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
    GROUP BY 
        `bairro`.`nome_bairro` 
    ORDER BY 
        total DESC 
    LIMIT 3;
END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_crime`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_crime` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20) CHARSET utf8, IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
	SELECT 
        `ocorrencia`.`tipo` AS nome, COUNT(`ocorrencia`.`tipo`) AS total 
    FROM 
        `ocorrencia`
    INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
    GROUP BY 
        `ocorrencia`.`tipo` 
    ORDER BY 
        total DESC 
    LIMIT 3;
END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_dia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_dia` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
		SELECT
			DAYOFWEEK(DATE(`ocorrencia`.`data_hora`)) AS nome, 
			COUNT(DAYOFWEEK(DATE(`ocorrencia`.`data_hora`))) AS total 
		FROM 
			`ocorrencia`
		INNER JOIN 
			`bairro` ON (
                `ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
            ) 
		INNER JOIN 
			`area` ON (
                `area`.`codigo` = `bairro`.`area_codigo`
            )
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
	    GROUP BY 
        	DAYOFWEEK(DATE(`ocorrencia`.`data_hora`)) 
        ORDER BY 
        	total DESC 
        LIMIT 3;
	END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_hora`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_hora` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20) CHARSET utf8, IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
		SELECT
			HOUR(`ocorrencia`.`data_hora`) AS nome, 
            COUNT(HOUR(`ocorrencia`.`data_hora`)) AS total
		FROM 
			`ocorrencia`
		INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
	    GROUP BY 
        	HOUR(`ocorrencia`.`data_hora`) 
        ORDER BY 
        	total DESC
        LIMIT 3;
	END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_mes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_mes` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20) CHARSET utf8, IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
		SELECT
			MONTH(`ocorrencia`.`data_hora`) AS nome, 
            COUNT(MONTH(`ocorrencia`.`data_hora`)) AS total
		FROM 
			`ocorrencia`
		INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
	    GROUP BY 
        	MONTH(`ocorrencia`.`data_hora`) 
        ORDER BY 
        	total DESC
	    LIMIT 3;
	END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_objeto`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_objeto` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
		SELECT 
	        `item_roubo`.`item` AS nome, SUM(`item_roubo`.`quantidade`) AS total
	    FROM 
	        `ocorrencia` 
	    INNER JOIN 
			`bairro` ON (
					`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)	
		INNER JOIN
			`item_roubo` ON (
				`item_roubo`.`ocorrencia_codigo` = `ocorrencia`.`codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
	    GROUP BY 
	    	`item_roubo`.`item` 
	    ORDER BY 
	    	total DESC
	    LIMIT 3;
	END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_rua`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_rua` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
	SELECT 
        `ocorrencia`.`rua` AS nome, COUNT(`ocorrencia`.`rua`) AS total 
    FROM 
        `ocorrencia`
    INNER JOIN 
			`bairro` ON (
				`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
			) 
		INNER JOIN 
			`area` ON (
				`area`.`codigo` = `bairro`.`area_codigo`
			)
	    WHERE
	    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
	        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
	        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
	        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
	    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
    GROUP BY 
        `ocorrencia`.`rua` 
    ORDER BY 
        total DESC
    LIMIT 3;
END$$

DROP PROCEDURE IF EXISTS `SP_get_datas_chart_series_temporal`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_datas_chart_series_temporal` (IN `mes` INT(2), IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `anoPeriodo` INT(4))  NO SQL
BEGIN
	SELECT
    	`ocorrencia`.`tipo`AS nome, 
        COUNT(`ocorrencia`.`tipo`) AS total 
	FROM 
    	`ocorrencia`
     INNER JOIN 
     	`bairro` ON (
            `ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
        )
	INNER JOIN 
    	`area` ON (
            `area`.`codigo` = `bairro`.`area_codigo`
        )
    WHERE
    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
        MONTH(`ocorrencia`.`data_hora`) = mes AND
        YEAR(`ocorrencia`.`data_hora`) = anoPeriodo
    GROUP BY 
    	`ocorrencia`.`tipo`;
END$$

DROP PROCEDURE IF EXISTS `SP_get_envolvidos_pelo_nome`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_envolvidos_pelo_nome` (`nome` VARCHAR(50))  BEGIN
	SELECT 
		* 
	FROM 
		`envolvido`
    WHERE 
		LOWER(`envolvido`.`nome_envolvido`) LIKE CONCAT('%', LOWER(nome), '%');
END$$

DROP PROCEDURE IF EXISTS `SP_get_marcas_veiculos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_marcas_veiculos` (IN `tipoVeiculo` VARCHAR(50))  BEGIN
	SELECT 
		* 
	FROM 
		`marca_veiculo`
	WHERE
		LOWER(`tipo_veiculo`) LIKE CONCAT('%', LOWER(tipoVeiculo), '%');
END$$

DROP PROCEDURE IF EXISTS `SP_get_modelos_veiculos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_modelos_veiculos` (IN `veiculo_marca` VARCHAR(100))  BEGIN
	SELECT
		`modelo`.`codigo` AS `codigo`,
        `modelo`.`modelo` AS `modelo`,
        `modelo`.`marcaVeiculo_codigo` AS `marcaVeiculo_codigo`,
        `modelo`.`codigo` AS `codigo`,
        `marca`.`marca` AS `marca`,
        `marca`.`tipo_veiculo` AS `tipo_veiculo`
	FROM
		`modelo_veiculo` AS `modelo`
	INNER JOIN 
		`marca_veiculo` AS `marca`
	ON (
		`modelo`.`marcaVeiculo_codigo` = `marca`.`codigo`
	)
	WHERE
		LOWER(`marca`.`marca`) LIKE CONCAT('%', LOWER(veiculo_marca), '%');
END$$

DROP PROCEDURE IF EXISTS `SP_get_ocorrencia`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_ocorrencia` (IN `codigo` BIGINT(20))  NO SQL
BEGIN
	SELECT
		`ocorrencia`.`codigo` AS `codigo`,
		`ocorrencia`.`tipo` AS `tipo`,
		`ocorrencia`.`rua` AS `rua`,
		`ocorrencia`.`data_hora` AS `data_hora`,
		`ocorrencia`.`descricao` AS `descricao`,
		`ocorrencia`.`info_complementares` AS `info_complementares`,
        `ocorrencia`.`is_trote` AS `is_trote`,
		`ocorrencia`.`bairro_codigo` AS `bairro_codigo`,
		`bairro`.`nome_bairro` AS `nome_bairro`,
		`bairro`.`area_codigo` AS `area_codigo`,
		`area`.`nome_area` AS `nome_area`
	FROM 
		`ocorrencia`
	INNER JOIN 
		bairro ON (
			`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
		) 
	INNER JOIN 
		area ON (
			`area`.`codigo` = `bairro`.`area_codigo`
		)
	WHERE 
		`ocorrencia`.`codigo` = codigo;
END$$

DROP PROCEDURE IF EXISTS `SP_get_ocorrencias`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_ocorrencias` (IN `tipo` VARCHAR(100) CHARSET utf8, IN `area` VARCHAR(100) CHARSET utf8, IN `bairro` VARCHAR(100) CHARSET utf8, IN `rua` VARCHAR(100) CHARSET utf8, IN `dataInicial` VARCHAR(20), IN `dataFinal` VARCHAR(20))  NO SQL
BEGIN
	SELECT
		`ocorrencia`.`codigo` AS `codigo`,
		`ocorrencia`.`tipo` AS `tipo`,
		`ocorrencia`.`rua` AS `rua`,
		`ocorrencia`.`data_hora` AS `data_hora`,
		`ocorrencia`.`descricao` AS `descricao`,
		`ocorrencia`.`info_complementares` AS `info_complementares`,
        `ocorrencia`.`is_trote` AS `is_trote`,
		`ocorrencia`.`bairro_codigo` AS `bairro_codigo`,
		`bairro`.`nome_bairro` AS `nome_bairro`,
		`bairro`.`area_codigo` AS `area_codigo`,
		`area`.`nome_area` AS `nome_area`
	FROM 
		`ocorrencia`
	INNER JOIN 
		`bairro` ON (
			`ocorrencia`.`bairro_codigo` = `bairro`.`codigo`
		) 
	INNER JOIN 
		`area` ON (
			`area`.`codigo` = `bairro`.`area_codigo`
		)
    WHERE
    	LOWER(`ocorrencia`.`tipo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
        LOWER(`area`.`nome_area`) LIKE LOWER(CONCAT('%', area, '%')) AND
        LOWER(`bairro`.`nome_bairro`) LIKE LOWER(CONCAT('%', bairro, '%')) AND
        LOWER(`ocorrencia`.`rua`) LIKE LOWER(CONCAT('%', rua, '%')) AND
    	`ocorrencia`.`data_hora` BETWEEN TIMESTAMP(dataInicial) AND TIMESTAMP(dataFinal)
    ORDER BY `ocorrencia`.`data_hora` DESC;
END$$

DROP PROCEDURE IF EXISTS `SP_get_ocorrencia_envolvidos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_ocorrencia_envolvidos` (IN `ocorrencia_codigo` INT(20))  NO SQL
BEGIN
    SELECT 
    	`envolvido`.`codigo` AS `codigo`,
        `ocorrencia_has_envolvido`.`envolvido` AS `tipo_envolvido`,
        `envolvido`.`cpf` AS `cpf`,
        `envolvido`.`data_nascimento` AS `data_nascimento`,
        `envolvido`.`endereco` AS `endereco`,
        `envolvido`.`nome_envolvido` AS `nome_envolvido`,
        `envolvido`.`num_contato` AS `num_contato`,
        `envolvido`.`rg` AS `rg` 
    FROM 
    	`envolvido` 
    INNER JOIN 
    	`ocorrencia_has_envolvido` ON (
            `ocorrencia_has_envolvido`.`envolvido_codigo` = `envolvido`.`codigo`
        ) 
    INNER JOIN 
    	`ocorrencia` ON (
            `ocorrencia`.`codigo` = `ocorrencia_has_envolvido`.`ocorrencia_codigo`
        )
    WHERE 
    	`ocorrencia`.`codigo` = ocorrencia_codigo;
END$$

DROP PROCEDURE IF EXISTS `SP_get_ocorrencia_itens_roubo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_ocorrencia_itens_roubo` (IN `ocorrencia_codigo` BIGINT(20))  NO SQL
BEGIN
	SELECT 
    	`item_roubo`.`codigo` AS `codigo`,
        `item_roubo`.`item` AS `item`,
        `item_roubo`.`quantidade` AS `quantidade` 
    FROM 
    	`item_roubo` 
    INNER JOIN 
    	`ocorrencia` ON (
            `item_roubo`.`ocorrencia_codigo` = `ocorrencia`.`codigo`
        ) 
    WHERE 
    	`ocorrencia`.`codigo` = ocorrencia_codigo;
END$$

DROP PROCEDURE IF EXISTS `SP_get_ocorrencia_veiculos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_ocorrencia_veiculos` (IN `ocorrencia_codigo` BIGINT(20))  NO SQL
BEGIN
	SELECT 
		`veiculo`.`codigo` AS `codigo`,
                `veiculo`.`chassi` AS `chassi`,
                `veiculo`.`placa` AS `placa`,
                `veiculo`.`modeloVeiculo_codigo` AS `modelo_codigo`,
                `veiculo`.`cor_veiculo` AS `cor`,
                `modelo`.`marcaVeiculo_codigo` AS `marca_codigo`,
                `modelo`.`modelo` AS `modelo`,
                `marca`.`marca` AS `marca`,
                `marca`.`tipo_veiculo` AS `tipo_veiculo`
	FROM
		`veiculo`
	INNER JOIN
		`modelo_veiculo` AS `modelo`
	ON (
		`veiculo`.`modeloVeiculo_codigo` = `modelo`.`codigo`
	)
	INNER JOIN 
		`marca_veiculo` AS `marca`
	ON (
		`modelo`.`marcaVeiculo_codigo` = `marca`.`codigo`
	)
    INNER JOIN
    	`ocorrencia_has_veiculo`
    ON (
    	`veiculo`.`codigo` = `ocorrencia_has_veiculo`.`veiculo_codigo`
    )
    INNER JOIN
    	`ocorrencia`
    ON (
    	`ocorrencia`.`codigo` = `ocorrencia_has_veiculo`.`ocorrencia_codigo`
    )
	WHERE
		`ocorrencia`.`codigo` = ocorrencia_codigo;
END$$

DROP PROCEDURE IF EXISTS `SP_get_veiculos`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_veiculos` (IN `tipo` VARCHAR(50) CHARSET utf8, IN `marca` VARCHAR(50) CHARSET utf8, IN `modelo` VARCHAR(50) CHARSET utf8, IN `placa` VARCHAR(10) CHARSET utf8)  NO SQL
BEGIN
	SELECT 
		`veiculo`.`codigo` AS `codigo`,
		`veiculo`.`chassi` AS `chassi`,
		`veiculo`.`placa` AS `placa`,
		`veiculo`.`cor_veiculo` AS `cor`,
		`modelo_veiculo`.`codigo` AS `modelo_codigo`,
		`modelo_veiculo`.`modelo` AS `modelo`,
		`marca_veiculo`.`codigo` AS `marca_codigo`,
		`marca_veiculo`.`marca` AS `marca`,
		`marca_veiculo`.`tipo_veiculo` AS `tipo_veiculo`
	FROM
		`veiculo`
	INNER JOIN
		`modelo_veiculo` ON (
			`modelo_veiculo`.`codigo` = `veiculo`.`modeloVeiculo_codigo`
		)
	INNER JOIN 
		`marca_veiculo` ON (
			`modelo_veiculo`.`marcaVeiculo_codigo` = `marca_veiculo`.`codigo`
		)
	WHERE (
		LOWER(`marca_veiculo`.`tipo_veiculo`) LIKE LOWER(CONCAT('%', tipo, '%')) AND
		LOWER(`marca_veiculo`.`marca`) LIKE LOWER(CONCAT('%', marca, '%')) AND
		LOWER(`modelo_veiculo`.`modelo`) LIKE LOWER(CONCAT('%', modelo, '%')) AND
		LOWER(`veiculo`.`placa`) LIKE LOWER(CONCAT('%', placa, '%'))
	);
END$$

DROP PROCEDURE IF EXISTS `SP_get_veiculo_por_placa`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_get_veiculo_por_placa` (IN `placa` VARCHAR(15))  BEGIN
	SELECT 
		`veiculo`.`codigo` AS `codigo`,
                `veiculo`.`chassi` AS `chassi`,
                `veiculo`.`placa` AS `placa`,
                `veiculo`.`modeloVeiculo_codigo` AS `modelo_codigo`,
                `veiculo`.`cor_veiculo` AS `cor`,
                `modelo`.`marcaVeiculo_codigo` AS `marca_codigo`,
                `modelo`.`modelo` AS `modelo`,
                `marca`.`marca` AS `marca`,
                `marca`.`tipo_veiculo` AS `tipo_veiculo`
	FROM
		`veiculo`
	INNER JOIN
		`modelo_veiculo` AS `modelo`
	ON (
		`veiculo`.`modeloVeiculo_codigo` = `modelo`.`codigo`
	)
	INNER JOIN 
		`marca_veiculo` AS `marca`
	ON (
		`modelo`.`marcaVeiculo_codigo` = `marca`.`codigo`
	)
	WHERE
		LOWER(`veiculo`.`placa`) LIKE CONCAT('%', LOWER(placa), '%');
END$$

--
-- Functions
--
DROP FUNCTION IF EXISTS `atualizar_ocorrencia`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `atualizar_ocorrencia` (`codigo` BIGINT(20), `tipo` VARCHAR(70) CHARSET utf8, `rua` VARCHAR(100) CHARSET utf8, `dataHora` VARCHAR(20), `descricao` LONGTEXT CHARSET utf8, `infoComplementares` LONGTEXT CHARSET utf8, `isTrote` TINYINT(1), `bairroCodigo` BIGINT(20)) RETURNS BIGINT(20) NO SQL
BEGIN
	
    DECLARE ocorrenciaCodigo BIGINT DEFAULT 0;
    
	UPDATE 
		`ocorrencia` 
	SET
		`ocorrencia`.`tipo` 			   = tipo,
		`ocorrencia`.`rua`  			   = rua,
		`ocorrencia`.`data_hora`           = TIMESTAMP(dataHora),
		`ocorrencia`.`descricao` 		   = descricao,
		`ocorrencia`.`info_complementares` = infoComplementares,
		`ocorrencia`.`is_trote` 		   = isTrote,
		`ocorrencia`.`bairro_codigo` 	   = bairroCodigo
	WHERE
		`ocorrencia`.`codigo` 			   = codigo;
       
    SELECT `ocorrencia`.`codigo` FROM `ocorrencia` WHERE `ocorrencia`.`codigo` = codigo INTO ocorrenciaCodigo;
    
    IF (ocorrenciaCodigo <> 0) THEN
    	RETURN ocorrenciaCodigo;
    END IF;
     
    RETURN false;
END$$

DROP FUNCTION IF EXISTS `atualizar_usuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `atualizar_usuario` (`codigo` BIGINT(20), `nome` VARCHAR(100) CHARSET utf8, `email` VARCHAR(100) CHARSET utf8, `postoGraduacao` VARCHAR(50) CHARSET utf8, `rgMilitar` VARCHAR(10) CHARSET utf8, `tipo` VARCHAR(50) CHARSET utf8, `senha` VARCHAR(100) CHARSET utf8) RETURNS BIGINT(20) NO SQL
BEGIN
	UPDATE 
    	`usuario` 
    SET
    	`usuario`.`nome_usuario` = nome,
        `usuario`.`email` = email,
        `usuario`.`posto_ou_graduacao` = postoGraduacao,
        `usuario`.`rg_militar` = rgMilitar,
        `usuario`.`tipo` = tipo
    WHERE
    	`usuario`.`codigo` = codigo;
    
    IF (senha) THEN
    	UPDATE 
        	`usuario` 
        SET 
        	`usuario`.`senha` = UPPER(MD5(senha))
        WHERE
        	`usuario`.`codigo` = codigo;
    END IF;
    
    RETURN codigo;
END$$

DROP FUNCTION IF EXISTS `cadastrar_envolvido`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `cadastrar_envolvido` (`nome` VARCHAR(100) CHARSET utf8, `cpf` VARCHAR(20) CHARSET utf8, `rg` VARCHAR(20) CHARSET utf8, `numContato` VARCHAR(25) CHARSET utf8, `endereco` VARCHAR(150) CHARSET utf8, `dataNascimento` VARCHAR(15)) RETURNS TINYINT(4) NO SQL
BEGIN
	DECLARE codigo BIGINT DEFAULT 0;

	INSERT INTO 
		`envolvido` (
			`nome_envolvido`, `cpf`, `rg`, `num_contato`, `endereco`, `data_nascimento`
		)
	VALUES (
		nome, cpf, rg, numContato, endereco, DATE(dataNascimento)
	);

	SELECT MAX(`envolvido`.`codigo`) FROM `envolvido` INTO codigo;

	IF (codigo) THEN
		RETURN codigo;
	END IF;

	RETURN 0;
END$$

DROP FUNCTION IF EXISTS `cadastrar_ocorrencia`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `cadastrar_ocorrencia` (`tipo` VARCHAR(100), `rua` VARCHAR(150), `dataHora` VARCHAR(25), `descricao` LONGTEXT, `info_complementares` LONGTEXT, `bairro` BIGINT(20), `trote` TINYINT(1)) RETURNS TINYINT(1) BEGIN
	
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
END$$

DROP FUNCTION IF EXISTS `cadastrar_usuario`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `cadastrar_usuario` (`nome` VARCHAR(100) CHARSET utf8, `email` VARCHAR(100) CHARSET utf8, `posto_ou_graduacao` VARCHAR(50) CHARSET utf8, `rg_militar` VARCHAR(10) CHARSET utf8, `senha` VARCHAR(70) CHARSET utf8, `tipo` VARCHAR(50) CHARSET utf8) RETURNS BIGINT(20) NO SQL
BEGIN
	
	DECLARE usuarioCodigo BIGINT(20) DEFAULT 0;
    
	INSERT INTO 
    	`usuario` (
            `nome_usuario`, `email`, `posto_ou_graduacao`, `rg_militar`, `senha`, `tipo`
        )
    VALUES (
    	nome, email, posto_ou_graduacao, rg_militar, UPPER(MD5(senha)), tipo
    );
    
    SELECT MAX(`usuario`.`codigo`) FROM `usuario` INTO usuarioCodigo;
    
    RETURN usuarioCodigo;
END$$

DROP FUNCTION IF EXISTS `get_contato`$$
CREATE DEFINER=`root`@`localhost` FUNCTION `get_contato` (`codigo` BIGINT(20)) RETURNS VARCHAR(20) CHARSET utf8 NO SQL
BEGIN

	DECLARE contato VARCHAR(20) DEFAULT '';

    SELECT 
        `envolvido`.`num_contato` AS `contato` 
    FROM 
        `envolvido` 
    INNER JOIN 
        `ocorrencia_has_envolvido` ON (
            `envolvido`.`codigo` = `ocorrencia_has_envolvido`.`envolvido_codigo`
        ) 
    INNER JOIN 
        `ocorrencia` ON (
            `ocorrencia_has_envolvido`.`ocorrencia_codigo` = `ocorrencia`.`codigo`
        )
    INNER JOIN 
        `ocorrencia_has_veiculo` ON (
            `ocorrencia`.`codigo` = `ocorrencia_has_veiculo`.`ocorrencia_codigo`
        )
    INNER JOIN 
        `veiculo` ON (
            `veiculo`.`codigo` = `ocorrencia_has_veiculo`.`veiculo_codigo`
        ) 
    WHERE 
        `ocorrencia_has_envolvido`.`envolvido` = "Vitima" AND 
        `veiculo`.`codigo` = codigo 
    ORDER BY 
        `envolvido`.`codigo` DESC
    LIMIT 
        1
    INTO contato;
    
    RETURN contato;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
CREATE TABLE `area` (
  `codigo` bigint(20) NOT NULL,
  `nome_area` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `area`
--

TRUNCATE TABLE `area`;
--
-- Dumping data for table `area`
--

INSERT INTO `area` (`codigo`, `nome_area`) VALUES
(2, '1ª Companhia'),
(3, '2ª Companhia'),
(1, 'Castanhal');

-- --------------------------------------------------------

--
-- Table structure for table `bairro`
--

DROP TABLE IF EXISTS `bairro`;
CREATE TABLE `bairro` (
  `codigo` bigint(20) NOT NULL,
  `nome_bairro` varchar(150) NOT NULL,
  `area_codigo` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `bairro`
--

TRUNCATE TABLE `bairro`;
--
-- Dumping data for table `bairro`
--

INSERT INTO `bairro` (`codigo`, `nome_bairro`, `area_codigo`) VALUES
(1, 'Ianetama', 3),
(2, 'Santa Catarina', 3),
(3, 'Milagre', 3),
(4, 'Jaderlandia', 3),
(5, 'Estrela', 2),
(6, 'Pirapora', 3),
(7, 'Propira', 2),
(8, 'Novo Estrela', 2),
(9, 'Cohab', 2),
(10, 'Salgadinho', 3);

-- --------------------------------------------------------

--
-- Table structure for table `envolvido`
--

DROP TABLE IF EXISTS `envolvido`;
CREATE TABLE `envolvido` (
  `codigo` bigint(20) NOT NULL,
  `cpf` varchar(20) DEFAULT NULL,
  `data_nascimento` date DEFAULT NULL,
  `endereco` varchar(150) DEFAULT NULL,
  `nome_envolvido` varchar(150) NOT NULL,
  `num_contato` varchar(25) DEFAULT NULL,
  `rg` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `envolvido`
--

TRUNCATE TABLE `envolvido`;
--
-- Dumping data for table `envolvido`
--

INSERT INTO `envolvido` (`codigo`, `cpf`, `data_nascimento`, `endereco`, `nome_envolvido`, `num_contato`, `rg`) VALUES
(1, '123.456.789-78', '2017-09-04', 'Rua', 'Luis Inacio da Silva', '(91) 9 8945-8457', '456789-2'),
(2, '123.456.789-79', '2017-09-03', 'Rua das Flores', 'Michel Temer', '(91) 9 8547-8956', '897458-4'),
(3, '541.351.351.53', NULL, NULL, 'Joesley Batista', '(91) 9 9045-0956', '131531-3'),
(4, '777.777.777.77', NULL, 'Cadeia', 'Lula', '(91) 9 8976-4532', '111111-1'),
(10, '999.999.999-99', '1995-11-10', 'Rua Juscelino Kubitschek - 108', 'Juan Soares', '(99) 9 9999-9999', '999999-9'),
(11, '123.456.702-22', '2017-12-19', 'Rua JK - 104', 'Arthur Gabriel', '(99) 9 9999-9999', '222222-4'),
(12, '453.576.788-88', '2014-12-23', 'Rua Juscelino Kubitschek - 104', 'Sophia Soares', '(99) 9 9999-9999', '666666-6');

-- --------------------------------------------------------

--
-- Table structure for table `item_roubo`
--

DROP TABLE IF EXISTS `item_roubo`;
CREATE TABLE `item_roubo` (
  `codigo` bigint(20) NOT NULL,
  `ocorrencia_codigo` bigint(20) NOT NULL,
  `item` varchar(100) NOT NULL,
  `quantidade` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `item_roubo`
--

TRUNCATE TABLE `item_roubo`;
--
-- Dumping data for table `item_roubo`
--

INSERT INTO `item_roubo` (`codigo`, `ocorrencia_codigo`, `item`, `quantidade`) VALUES
(1, 2, 'Arma', 1),
(2, 7, 'Anel', 3),
(3, 8, 'Bicicleta', 1),
(6, 10, 'Dinheiro', 2),
(7, 14, 'Dinheiro', 3),
(8, 14, 'Arma de fogo', 1),
(9, 14, 'Documento', 5),
(10, 14, 'Notebook', 1),
(11, 14, 'Celular', 3),
(12, 14, 'Cordão', 2),
(13, 14, 'Mochila', 2),
(14, 14, 'Sapato', 4),
(15, 14, 'Tablet', 1),
(16, 19, 'Arma de fogo', 1),
(17, 19, 'Celular', 2),
(18, 19, 'Sapato', 2);

-- --------------------------------------------------------

--
-- Table structure for table `marca_veiculo`
--

DROP TABLE IF EXISTS `marca_veiculo`;
CREATE TABLE `marca_veiculo` (
  `codigo` bigint(20) NOT NULL,
  `marca` varchar(25) NOT NULL,
  `tipo_veiculo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `marca_veiculo`
--

TRUNCATE TABLE `marca_veiculo`;
--
-- Dumping data for table `marca_veiculo`
--

INSERT INTO `marca_veiculo` (`codigo`, `marca`, `tipo_veiculo`) VALUES
(1, 'Fiat', 'Carro'),
(2, 'Renault', 'Carro'),
(3, 'Honda', 'Motocicleta'),
(4, 'Mercedez', 'Caminhão'),
(5, 'Chevrolet', 'Carro'),
(6, 'Yamaha', 'Motocicleta'),
(7, 'Volvo', 'Caminhão'),
(8, 'Scania', 'Caminhão'),
(9, 'Topique', 'Van');

-- --------------------------------------------------------

--
-- Table structure for table `modelo_veiculo`
--

DROP TABLE IF EXISTS `modelo_veiculo`;
CREATE TABLE `modelo_veiculo` (
  `codigo` bigint(20) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  `marcaVeiculo_codigo` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `modelo_veiculo`
--

TRUNCATE TABLE `modelo_veiculo`;
--
-- Dumping data for table `modelo_veiculo`
--

INSERT INTO `modelo_veiculo` (`codigo`, `modelo`, `marcaVeiculo_codigo`) VALUES
(1, 'Palio', 1),
(2, 'Siena', 1),
(3, 'Clio', 2),
(4, 'Sandero', 2),
(5, 'Fan 150', 3),
(6, 'Titan', 3),
(7, 'Broz', 3),
(8, 'Prisma', 5),
(9, 'Celta', 5),
(10, 'Cobalt', 5),
(11, 'Fazer', 6),
(12, 'Volvo top', 7),
(13, 'Turbo', 8),
(14, 'Scania 15', 8),
(15, 'Topique 18P', 9);

-- --------------------------------------------------------

--
-- Table structure for table `ocorrencia`
--

DROP TABLE IF EXISTS `ocorrencia`;
CREATE TABLE `ocorrencia` (
  `codigo` bigint(20) NOT NULL,
  `data_hora` datetime NOT NULL,
  `descricao` longtext,
  `info_complementares` longtext,
  `rua` varchar(150) NOT NULL,
  `tipo` varchar(100) NOT NULL,
  `is_trote` tinyint(1) NOT NULL,
  `bairro_codigo` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `ocorrencia`
--

TRUNCATE TABLE `ocorrencia`;
--
-- Dumping data for table `ocorrencia`
--

INSERT INTO `ocorrencia` (`codigo`, `data_hora`, `descricao`, `info_complementares`, `rua`, `tipo`, `is_trote`, `bairro_codigo`) VALUES
(1, '2017-09-13 12:09:03', 'Briga de vizinho', 'Vias de fato', 'Cônego Leitão', 'Lesão corporal', 0, 6),
(2, '2017-09-13 12:21:41', 'Dois elementos armados em uma moto', 'Foi recuperado no cupiuba', 'Adailson Rodrigues', 'Roubo', 0, 4),
(3, '2010-10-23 10:03:00', 'Roubo em uma rua qualquer', 'Roubaram alguém', 'Rua Qualquer', 'Roubo', 0, 4),
(4, '2014-07-08 18:00:00', 'Furto', 'Furto', 'Rua Sei lá', 'Furto', 0, 3),
(5, '2017-11-10 11:11:00', 'Furto', NULL, 'JK - 105', 'Furto', 0, 1),
(6, '2017-11-10 11:11:00', 'Furto', 'Furto', 'JK - 105', 'Furto', 0, 1),
(7, '2007-06-25 10:11:00', 'Furto', 'Furto', 'Avenida - 800', 'Furto', 0, 3),
(8, '2018-07-25 22:30:00', 'Furto de bicicleta', 'Furto de bicicleta', 'Rua Novo Estrela', 'Furto', 0, 8),
(9, '2018-01-11 10:50:00', 'Roubo seguido de morte', 'Roubaram e mataram', 'Rua Estrela', 'Latrocínio', 0, 5),
(10, '2018-07-11 09:45:00', 'Roubo no propira', 'Roubaram o cara e depois mataram', 'Rua do Propira', 'Latrocínio', 0, 7),
(11, '2018-07-13 10:50:00', 'Crime de Prevaricação', 'O cara prevaricou', 'Rua Propira', 'Prevaricação', 0, 7),
(12, '2018-07-14 12:45:00', 'Furto na 1º de Janeiro', 'Furtaram uma moto', 'Rua 1º de Janeiro', 'Furto', 0, 9),
(13, '2018-07-16 02:10:00', 'Assédio moral', 'Assédio moral no Propira', 'Rua Professor Propira', 'Assédio', 0, 7),
(14, '2018-07-16 08:40:00', 'Roubaram um bocado de coisa', 'Mataram o cara e levaram tudo que ele tinha', 'Rua 1º de Janeiro', 'Latrocínio', 0, 9),
(15, '2018-07-30 18:30:00', 'Descrição', 'Complemento', 'Rua da Cohab', 'Arrombamento', 0, 9),
(16, '2018-08-01 13:45:00', 'Corrupção Passiva', 'Complemento', 'Rua Maximino Porpino', 'Corrupção Passiva', 0, 5),
(17, '2018-07-29 16:40:00', 'Chamo o cara de macaco', 'Complemento', 'Rua Anastácio de Melo', 'Injúria racial', 0, 10),
(18, '2018-07-31 09:45:00', 'Depredaram uma loja', 'Complemento', 'Rua Maximino Porpino', 'Vandalismo', 0, 5),
(19, '2018-05-14 09:45:00', 'Mataram e roubaram um policial', 'Levaram tudo do cara inclusive os sapatos e arma', 'Rua Catarina', 'Latrocínio', 0, 2),
(22, '2018-07-31 00:10:00', 'Mataram o cara a facadas próximo a casa do Zé do Ovo', 'Crime passional', 'TV. Passagem Têxtil', 'Homicídio', 0, 1),
(23, '2018-07-31 09:45:00', 'Crime de peculato', 'Complemento', 'Rua Marechal Deodoro', 'Peculato', 0, 1),
(24, '2018-07-30 17:25:00', 'Depredaram uma loja', 'Complemento', 'Rua Maximino Porpino', 'Vandalismo', 1, 8);

--
-- Triggers `ocorrencia`
--
DROP TRIGGER IF EXISTS `TRG_delete_ocorrencia_envolvido`;
DELIMITER $$
CREATE TRIGGER `TRG_delete_ocorrencia_envolvido` BEFORE UPDATE ON `ocorrencia` FOR EACH ROW BEGIN
	DELETE FROM
    	`ocorrencia_has_envolvido` 
    WHERE 
    	`ocorrencia_has_envolvido`.`ocorrencia_codigo` = OLD.codigo;
        
     DELETE FROM 
   	 	`ocorrencia_has_veiculo`
     WHERE
     	`ocorrencia_has_veiculo`.`ocorrencia_codigo` = OLD.codigo;
        
     DELETE FROM 
   	 	`item_roubo`
     WHERE
     	`item_roubo`.`ocorrencia_codigo` = OLD.codigo;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ocorrencia_has_envolvido`
--

DROP TABLE IF EXISTS `ocorrencia_has_envolvido`;
CREATE TABLE `ocorrencia_has_envolvido` (
  `envolvido` varchar(255) NOT NULL,
  `ocorrencia_codigo` bigint(20) NOT NULL,
  `envolvido_codigo` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `ocorrencia_has_envolvido`
--

TRUNCATE TABLE `ocorrencia_has_envolvido`;
--
-- Dumping data for table `ocorrencia_has_envolvido`
--

INSERT INTO `ocorrencia_has_envolvido` (`envolvido`, `ocorrencia_codigo`, `envolvido_codigo`) VALUES
('Acusado', 1, 1),
('Vitima', 1, 4),
('Vitima', 2, 1),
('Acusado', 2, 2),
('Vitima', 3, 3),
('Acusado', 7, 2),
('Acusado', 8, 2),
('Vitima', 8, 10),
('Testemunha', 8, 11),
('Acusado', 10, 2),
('Vitima', 10, 10),
('Acusado', 11, 11),
('Acusado', 12, 2),
('Testemunha', 12, 11),
('Vitima', 12, 12),
('Acusado', 13, 2),
('Testemunha', 13, 11),
('Vitima', 13, 12),
('Acusado', 14, 3),
('Vitima', 14, 10),
('Testemunha', 14, 12),
('Acusado', 15, 4),
('Vitima', 15, 11),
('Acusado', 16, 1),
('Acusado', 16, 2),
('Acusado', 16, 3),
('Acusado', 17, 1),
('Vitima', 17, 11),
('Testemunha', 17, 12),
('Acusado', 18, 10),
('Acusado', 19, 1),
('Acusado', 19, 2),
('Vitima', 19, 3),
('Vitima', 22, 11),
('Acusado', 22, 12),
('Acusado', 23, 11),
('Acusado', 24, 1);

-- --------------------------------------------------------

--
-- Table structure for table `ocorrencia_has_veiculo`
--

DROP TABLE IF EXISTS `ocorrencia_has_veiculo`;
CREATE TABLE `ocorrencia_has_veiculo` (
  `veiculo_codigo` bigint(20) NOT NULL,
  `ocorrencia_codigo` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `ocorrencia_has_veiculo`
--

TRUNCATE TABLE `ocorrencia_has_veiculo`;
--
-- Dumping data for table `ocorrencia_has_veiculo`
--

INSERT INTO `ocorrencia_has_veiculo` (`veiculo_codigo`, `ocorrencia_codigo`) VALUES
(1, 1),
(1, 2),
(1, 7),
(1, 8),
(2, 7),
(2, 14),
(2, 19),
(3, 3),
(13, 12);

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE `usuario` (
  `codigo` bigint(20) NOT NULL,
  `nome_usuario` varchar(25) NOT NULL,
  `posto_ou_graduacao` varchar(20) NOT NULL,
  `tipo` varchar(20) NOT NULL,
  `rg_militar` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `usuario`
--

TRUNCATE TABLE `usuario`;
--
-- Dumping data for table `usuario`
--

INSERT INTO `usuario` (`codigo`, `nome_usuario`, `posto_ou_graduacao`, `tipo`, `rg_militar`, `email`, `senha`) VALUES
(9, 'Juan Soares', 'Sargento', 'Administrador', '12345', 'wjuan.ps@gmail.com', 'E10ADC3949BA59ABBE56E057F20F883E'),
(10, 'Jorge da Fonseca', 'Soldado', 'Atendente', '99999', 'fonseca@fonseca.com', '52C69E3A57331081823331C4E69D3F2E'),
(11, 'Pedro dos Santos', 'Cabo', 'Atendente', '77777', 'peter@gmail.com', 'F63F4FBC9F8C85D409F2F59F2B9E12D5');

-- --------------------------------------------------------

--
-- Table structure for table `veiculo`
--

DROP TABLE IF EXISTS `veiculo`;
CREATE TABLE `veiculo` (
  `codigo` bigint(20) NOT NULL,
  `chassi` varchar(20) DEFAULT NULL,
  `placa` varchar(10) NOT NULL,
  `modeloVeiculo_codigo` bigint(20) DEFAULT NULL,
  `cor_veiculo` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Truncate table before insert `veiculo`
--

TRUNCATE TABLE `veiculo`;
--
-- Dumping data for table `veiculo`
--

INSERT INTO `veiculo` (`codigo`, `chassi`, `placa`, `modeloVeiculo_codigo`, `cor_veiculo`) VALUES
(1, '9A9AA9999AA999999', 'OTA-1990', 10, 'Preta'),
(2, '1S1GS3131SD351313', 'AAA-4513', 4, 'Azul'),
(3, '4A3DV3515HD113131', 'FAW-3451', 11, 'Branca'),
(4, '4G4KD5146YD651146', 'CCC-4513', 2, 'Prata'),
(5, '9A9AA9999AA999999', 'OOO-1234', 2, 'Branca'),
(6, '9A9AA9999AA999993', 'OOV-3453', 3, 'Preta'),
(7, '9A9AA9999AA999992', 'AAM-5678', 7, 'Verde'),
(8, '9A9AA9999BA999992', 'MKJ-9078', 1, 'Amarela'),
(10, '9A9CA9999BA999992', 'MKJ-4523', 9, 'Cinza'),
(11, '9A9AA9999BA909992', 'MIT-5498', 8, 'Prata'),
(12, '1S1GS3131SD351311', 'LLI-8900', 3, 'Azul'),
(13, '4A3DVS515HD113131', 'DKL-8976', 6, 'Vermelha'),
(14, '4A3DV3515KD113131', 'DKJ-3029', 15, 'Cinza'),
(15, '1S1GS3231SD351313', 'FDG-2134', 12, 'Prata'),
(16, '9AHU398FH80FHV89H', 'OPT-4587', 11, 'Prata');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `UK_k8jo5f0drnw8viks47s0mdnyt` (`nome_area`);

--
-- Indexes for table `bairro`
--
ALTER TABLE `bairro`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `UK_sjtefwfx4nuiadj2mt6tmt4j2` (`nome_bairro`),
  ADD KEY `FK_o280973am9usa4mx5nuk3tk8f` (`area_codigo`);

--
-- Indexes for table `envolvido`
--
ALTER TABLE `envolvido`
  ADD PRIMARY KEY (`codigo`);

--
-- Indexes for table `item_roubo`
--
ALTER TABLE `item_roubo`
  ADD PRIMARY KEY (`codigo`,`ocorrencia_codigo`),
  ADD KEY `Fk_ocorrencia_itemRoubo` (`ocorrencia_codigo`);

--
-- Indexes for table `marca_veiculo`
--
ALTER TABLE `marca_veiculo`
  ADD PRIMARY KEY (`codigo`);

--
-- Indexes for table `modelo_veiculo`
--
ALTER TABLE `modelo_veiculo`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `FK_31jo6p1crt1dkrbkvfk324t62` (`marcaVeiculo_codigo`);

--
-- Indexes for table `ocorrencia`
--
ALTER TABLE `ocorrencia`
  ADD PRIMARY KEY (`codigo`),
  ADD KEY `FK_dm59webkk0oasnkiqigdx60rm` (`bairro_codigo`);

--
-- Indexes for table `ocorrencia_has_envolvido`
--
ALTER TABLE `ocorrencia_has_envolvido`
  ADD PRIMARY KEY (`ocorrencia_codigo`,`envolvido_codigo`),
  ADD KEY `FK_avl0qhdwed5wb6gleqq2tekn` (`envolvido_codigo`);

--
-- Indexes for table `ocorrencia_has_veiculo`
--
ALTER TABLE `ocorrencia_has_veiculo`
  ADD PRIMARY KEY (`veiculo_codigo`,`ocorrencia_codigo`),
  ADD KEY `FK_n6j99d1mpoblhs4g4snjnpvj8` (`ocorrencia_codigo`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `UK_b1myht3ujuqcsucloe25jxmwc` (`rg_militar`);

--
-- Indexes for table `veiculo`
--
ALTER TABLE `veiculo`
  ADD PRIMARY KEY (`codigo`),
  ADD UNIQUE KEY `UK_luoyk9d8idgi0wif7bxtefsr5` (`placa`),
  ADD KEY `FK_gb1l0lam8t61chqusycve8bee` (`modeloVeiculo_codigo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `area`
--
ALTER TABLE `area`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `bairro`
--
ALTER TABLE `bairro`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `envolvido`
--
ALTER TABLE `envolvido`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `item_roubo`
--
ALTER TABLE `item_roubo`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `marca_veiculo`
--
ALTER TABLE `marca_veiculo`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `modelo_veiculo`
--
ALTER TABLE `modelo_veiculo`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `ocorrencia`
--
ALTER TABLE `ocorrencia`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `veiculo`
--
ALTER TABLE `veiculo`
  MODIFY `codigo` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bairro`
--
ALTER TABLE `bairro`
  ADD CONSTRAINT `FK_o280973am9usa4mx5nuk3tk8f` FOREIGN KEY (`area_codigo`) REFERENCES `area` (`codigo`);

--
-- Constraints for table `item_roubo`
--
ALTER TABLE `item_roubo`
  ADD CONSTRAINT `Fk_ocorrencia_itemRoubo` FOREIGN KEY (`ocorrencia_codigo`) REFERENCES `ocorrencia` (`codigo`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `modelo_veiculo`
--
ALTER TABLE `modelo_veiculo`
  ADD CONSTRAINT `FK_31jo6p1crt1dkrbkvfk324t62` FOREIGN KEY (`marcaVeiculo_codigo`) REFERENCES `marca_veiculo` (`codigo`);

--
-- Constraints for table `ocorrencia`
--
ALTER TABLE `ocorrencia`
  ADD CONSTRAINT `FK_dm59webkk0oasnkiqigdx60rm` FOREIGN KEY (`bairro_codigo`) REFERENCES `bairro` (`codigo`);

--
-- Constraints for table `ocorrencia_has_envolvido`
--
ALTER TABLE `ocorrencia_has_envolvido`
  ADD CONSTRAINT `FK_avl0qhdwed5wb6gleqq2tekn` FOREIGN KEY (`envolvido_codigo`) REFERENCES `envolvido` (`codigo`),
  ADD CONSTRAINT `FK_p882hc6un7pbho4moe1fe7o65` FOREIGN KEY (`ocorrencia_codigo`) REFERENCES `ocorrencia` (`codigo`);

--
-- Constraints for table `ocorrencia_has_veiculo`
--
ALTER TABLE `ocorrencia_has_veiculo`
  ADD CONSTRAINT `FK_mryga80d1he9gm0lwlt9f644u` FOREIGN KEY (`veiculo_codigo`) REFERENCES `veiculo` (`codigo`),
  ADD CONSTRAINT `FK_n6j99d1mpoblhs4g4snjnpvj8` FOREIGN KEY (`ocorrencia_codigo`) REFERENCES `ocorrencia` (`codigo`);

--
-- Constraints for table `veiculo`
--
ALTER TABLE `veiculo`
  ADD CONSTRAINT `FK_gb1l0lam8t61chqusycve8bee` FOREIGN KEY (`modeloVeiculo_codigo`) REFERENCES `modelo_veiculo` (`codigo`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
