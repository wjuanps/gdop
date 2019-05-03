angular.module('gdop').controller('consultarEnvolvidosCtrl', function ($scope, envolvidoAPI) {

	$scope.init = function () {
		var _envolvidos       = envolvidoAPI.getEnvolvidos('');
		$scope.envolvidos     = _envolvidos.envolvidos;
		$scope.pages 		  = _envolvidos.pages;
		$scope.tiposEnvolvido = envolvidoAPI.getTiposEnvolvido();
	};

	$scope.pesquisarEnvolvido = function (nomeEnvolvido) {
		$scope.envolvidos = envolvidoAPI.getEnvolvidos(nomeEnvolvido);
	};

	$scope.resetarFiltros = function () {
		$scope.envolvidos = envolvidoAPI.getEnvolvidos('');
		delete $scope.nomeEnvolvido;
	};

});