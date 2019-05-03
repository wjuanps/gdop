angular.module("gdop").factory("genericAPI", function (gdopAPI) {

	var _request = function (option, arg) {
		var _dados = [];
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requests.php', {option: option, arg: arg}
		).then(
			function successCallback(response) {
				try {
					response.data.dados.forEach(function (elemento) {
						_dados.push(elemento);
					});
				} catch (e) {
					console.log(e);
				}
			}, function errorCallback(response) {
				console.log(response);
			}
		);
		return _dados;
	};

	return {
		request: _request
	};

});