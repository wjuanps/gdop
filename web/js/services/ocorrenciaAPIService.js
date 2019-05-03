angular.module("gdop").factory("ocorrenciaAPI", function (gdopAPI, genericAPI, dateAPI, filtroOcorrenciaAPI) {

	/*
	 *
	 *
	 */
	var _cadastrarOcorrencia = function (ocorrencia, arg) {
		var _ocorrencia = _prepararOcorrencia(angular.copy(ocorrencia));
		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/requests/requestCadastros.php', {option: 'ocorrencia', object: _ocorrencia, arg: arg}
		).then(
			function successCallback(response) {
				ocorrencia.codigo = response.data;
				if (ocorrencia.codigo > 0) {
					ocorrencia.success = true;
					setTimeout(function () {
						location.href = '/gdop/';
					}, 1000);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return ocorrencia;
	};

	/*
	 *
	 *
	 */
	var _prepararOcorrencia = function (ocorrencia) {
		try {
			if (ocorrencia.dataHora) {
				ocorrencia.dataHora = dateAPI.dateFormat(ocorrencia.dataHora);
			}

			if (!!ocorrencia.itensRoubo.length) {
				ocorrencia.itensRoubo = ocorrencia.itensRoubo.filter(function (elemento) {
					return elemento.item && elemento.quantidade;
				});
			}
		} catch (e) {
			console.log(e);
		}
		return ocorrencia;
	};

	var _getOcorrencias = function (filtro) {
		var _ocorrencias = [];
		var _filtro = filtroOcorrenciaAPI.prepararFiltro(filtro);
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requestOcorrencia.php', {filtro: _filtro}
		).then(
			function successCallback(response) {
				try {
					response.data.forEach(function (ocorrencia) {
						_ocorrencias.push(ocorrencia);
					});
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return _ocorrencias;
	};

	/*
	 *
	 *
	 */
	var _getOcorrencia = function (codigo) {
		var _ocorrencias = [];
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requestOcorrencia.php', {filtro: codigo}
		).then(
			function successCallback(response) {
				try {
					_ocorrencias.push(response.data);
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return _ocorrencias;
	}

	var _getTiposOcorrencia = function () {
		return genericAPI.request('tiposOcorrencia', null);
	};

	return {
		cadastrarOcorrencia: _cadastrarOcorrencia,
		getOcorrencias: _getOcorrencias,
		getOcorrencia: _getOcorrencia,
		prepararOcorrencia: _prepararOcorrencia,
		getTiposOcorrencia: _getTiposOcorrencia
	};
});