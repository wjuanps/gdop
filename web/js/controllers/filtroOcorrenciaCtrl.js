angular.module('gdop').controller('filtroOcorrenciaCtrl', function ($scope, ocorrenciaAPI, areaAPI, $filter) {

	$scope.initFiltro = function (callback) {
		$scope.tipos = ocorrenciaAPI.getTiposOcorrencia();
		$scope.areas = areaAPI.getAreas();
		$scope.resetarFiltros(callback);
	};

	$scope.getBairros = function (area) {
		$scope.bairros = areaAPI.getBairros(area);
	};

	$scope.resetarFiltros = function (callback) {
		var _filtro = {
			tipo: "",
			area: "",
			bairro: "",
			rua: "",
			dataInicial: "",
			dataFinal: "",
			anoPeriodo: $filter('date')(new Date(), 'yyyy')
		};
		$scope.filtro = _filtro;
		if (!!callback) {
			callback(_filtro);
		}
	};

});