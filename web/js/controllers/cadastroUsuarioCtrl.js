angular.module("gdop").controller("cadastroUsuarioCtrl", function ($scope, gdopAPI, $filter) {

	$scope.initUsuarioEditar = function () {
		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/services/requestSession.php',
			{option: 'get', name: 'editarPerfil', retorno: 'usuario'}
		).then(
			function successCallback(response) {
				try {
					var _usuario = angular.copy(response.data);
					if (!!_usuario.codigo) {
						$scope.usuario = _usuario;
					}
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.limparCampos = function () {
		delete $scope.usuario;
		$scope.formCadastro.$setPristine();
	}

	$scope.verificarDados = function (option, obj) {
		$scope.emailInvalido     = (option === 'checkEmail') ? false : $scope.emailInvalido;
		$scope.rgMilitarInvalido = (option === 'checkRGMilitar') ? false : $scope.rgMilitarInvalido;

		if (obj.$valid) {
			gdopAPI.ajaxPost(
				"src/com/wjuan/gdop/requests/requestCadastrarUsuario.php", {option: option, arg: obj.$modelValue}
			).then(
				function successCallBack(response) {
					var _status = response.data.status;
					$scope.emailInvalido     = (option === 'checkEmail' && _status === 'existeEmail') ? true : $scope.emailInvalido;
					$scope.rgMilitarInvalido = (option === 'checkRGMilitar' && _status === 'existeRGMilitar') ? true : $scope.rgMilitarInvalido;
				},
				function errorCallBack(response) {
					console.log(response);
				}
			);
		}
	};

	$scope.cadastrarUsuario = function (usuario) {
		var _acao = (!!usuario.codigo) ? "atualizar" : "cadastrar";

		if (_acao === "atualizar") {
			var _senhaNova   = angular.copy(usuario.senhaNova);
			var _senhaAntiga = angular.copy(usuario.senhaAntiga);
			usuario.senha = ((!!_senhaAntiga && !!_senhaNova) && (_senhaNova.length  >= 6 && _senhaAntiga.length >= 6)) ? _senhaNova : "";
		}

		usuario.nome = $filter('name')(usuario.nome);
		usuario.postoOuGraduacao = $filter('name')(usuario.postoOuGraduacao);
		gdopAPI.ajaxPost(
			"src/com/wjuan/gdop/requests/requestCadastrarUsuario.php", {option: 'cadastrarAtualizar', arg: _acao, usuario: usuario}
		).then(
			function successCallBack(response) {
				try {
					var _status = response.data.status;
					if (_status === 'success') {
						console.log(response.data);
						delete $scope.usuario;
						$scope.formCadastro.$setPristine();

						var _msg = (_acao === 'atualizar') ? " atualizado " : " realizado ";
						$scope.showMensagem = true;
						$scope.msg = "Cadastro" + _msg + "com sucesso!!";

						setTimeout(function () {
							location.href = '/gdop/';
						}, 2000);
					} else {
						$scope.emailInvalido     = (_status === 'email');
						$scope.rgMilitarInvalido = (_status === 'rgMilitar');
						console.log(response);
						$scope.showMensagem = true;
						$scope.msg = _status;
					}
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallBack(response) {
				console.log(response);
			}
		);
	};
});