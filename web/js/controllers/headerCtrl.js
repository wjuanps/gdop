angular.module("gdop").controller("headerCtrl", function ($scope, gdopAPI) {
	function inicializarUsuario() {
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestUsuario.php", null
		).then(
			function successCallBack(response) {
				if (response.data.usuario) {
					$scope.usuario = response.data.usuario;
					$scope.logado = true;
				}
			},
			function errorCallBack(response) {
				console.log(response);
			}
		);
	};
	
	$scope.logOut = function () {
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestLogout.php", null
		).then(
			function successCallBack(response) {
				if (response.data.sucesso) {
					location = location;
				}
			},
			function errorCallBack(response) {
				console.log(response);
			}
		);
	};

	inicializarUsuario();
});