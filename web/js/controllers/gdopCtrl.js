angular.module('gdop').controller('gdopCtrl', function ($scope, gdopAPI, sessionAPI) {

	$scope.initUser = function () {
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestUsuario.php", null
		).then(
			function successCallback(response) {
				delete $scope.usuarioLogado;
				var _status = response.data.status;
				if (_status === "success") {
					$scope.usuarioLogado = response.data.usuario;
					$scope.usuarioLogado.nomeAmigavel = response.data.nomeAmigavel;
				}
			}, function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.logarNoSistema = function (usuario) {
		$scope.erroNoLogin = false;
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestLogin.php",
			{option: 'login', rgMilitar: usuario.rgMilitar, senha: usuario.senha}
		).then(
			function successCallback(response) {
				if (response.data.status === "success") {
					location.href = '/gdop/';
				} else {
					$scope.erroNoLogin = true;
				}
			}, function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.deslogar = function () {
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestLogin.php",
			{option: 'logout'}
		).then(
			function successCallback(response) {
				location.reload();
			}, function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.editarUsuario = function (usuario) {
		sessionAPI.addOnSession('editarPerfil', usuario);
	};

});