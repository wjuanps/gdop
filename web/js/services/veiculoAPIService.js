angular.module("gdop").factory("veiculoAPI", function (gdopAPI, genericAPI) {

	var _cadastrarVeiculo = function (veiculo) {
		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/requests/requestCadastros.php', {option: 'veiculo', object: veiculo}
		).then(
			function successCallback(response) {
				veiculo.codigo = response.data.codigo;
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return veiculo;
	};

	var _getVeiculos = function (filtro) {
		var _veiculos = [];
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requestVeiculos.php', {filtro: filtro}
		).then(
			function successCallback(response) {
				try {
					response.data.forEach(function (veiculo) {
						_veiculos.push(veiculo);
					});
				} catch (e) {
					console.log(e)
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
		return _veiculos;
	}

	var _getTiposVeiculo = function () {
		return genericAPI.request('tiposVeiculo', null);
	};

	var _getCoresVeiculos = function () {
		return genericAPI.request('coresVeiculos', null);
	};

	return {
		cadastrarVeiculo: _cadastrarVeiculo,
		getVeiculos: _getVeiculos,
		getTiposVeiculo: _getTiposVeiculo,
		getCoresVeiculos: _getCoresVeiculos
	};

});