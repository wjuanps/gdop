angular.module('gdop').controller('chartCtrl', function ($scope, gdopAPI, chartAPI, filtroOcorrenciaAPI) {

	$scope.general = true;

	$scope.gerarGraficos = function(filtro, option) {
		$scope.charts = [];
		var _filtro = filtroOcorrenciaAPI.prepararFiltro(filtro);
		gdopAPI.ajaxGet(
			'src/com/wjuan/gdop/requests/requestDatasChart.php', {option: option, filtro: _filtro}
		).then(
			function successCallback(response) {
				try {
					let _datas = angular.copy(response.data);
					console.log(_datas);
					_renderizarGrafico(_datas, option, _filtro);
				} catch (e) {
					console.log(e);
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.reset = function (filtro) {
		$scope.gerarGraficos(filtro, $scope.general ? 'general': 'serieTemporalCrimes');
	};

	$scope.changeChart = function (filtro, id) {
		$scope.general = (id === 'general');
		$scope.gerarGraficos(filtro, id);
	};

	var _renderizarGrafico = function (charts, option, filtro) {
		try {
			if (option === 'serieTemporalCrimes') {
				$scope.lineChart = angular.copy(charts.dataSets);
				setTimeout(function () {
					let _crime  = " - Crime: " + (filtro.tipo || "Todos").concat(" - ");
					let _area   = " Área: " + (filtro.area || "Castanhal").concat(" - ");
					let _bairro = " Bairro: " + (filtro.bairro || "Todos");
					let _title  = "Ano: ".concat(filtro.anoPeriodo).concat(_crime).concat(_area).concat(_bairro);
					chartAPI.createLineChart(charts, _title, "Meses");
				}, 500);
			} else {
				$scope.charts = angular.copy(charts);
				setTimeout(function () {
					charts.forEach(function (chart) {
						chartAPI.createBarChart(chart);
					});
				}, 500);
			}
		} catch (e) {
			console.log(e);
		}
	};
});