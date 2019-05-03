angular.module("gdop").factory("envolvidoAPI", function (gdopAPI, genericAPI) {

	/**
	 *
	 *
	 */
	var _getEnvolvidos = function (nomeEnvolvido) {
		var _datas = {envolvidos: [], pages: []};
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requestEnvolvidos.php', {nome: nomeEnvolvido}
		).then(
			function successCallback(response) {
				try {
					if (!!response.data.length) {
						var _i = 0;
						response.data.forEach(function (envolvido) {
							_datas.envolvidos.push(envolvido);
							_datas.pages.push(++_i);
						});
					}
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return _datas;
	};

	/**
	 *
	 *
	 */
	var _cadastrarEnvolvido = function (envolvido) {
		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/requests/requestCadastros.php', {option: 'envolvido', object: envolvido}
		).then(
			function successCallback(response) {
                console.log(response);
				envolvido.codigo = response.data;
			},
			function errorCallback(response) {
				console.log(response);
			}
		);

		return envolvido;
	};

	/**
	 *
	 *
	 */
	var _getTiposEnvolvido = function () {
		return genericAPI.request('tiposEnvolvidos', null);
	};

	return {
		getEnvolvidos: _getEnvolvidos,
		cadastrarEnvolvido: _cadastrarEnvolvido,
		getTiposEnvolvido: _getTiposEnvolvido
	};
});