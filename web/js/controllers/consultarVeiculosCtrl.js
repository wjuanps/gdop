angular.module('gdop').controller('consultarVeiculosCtrl', function ($scope, veiculoAPI, genericAPI) {

	$scope.filtro = {};

	$scope.init = function () {
		$scope.tipos = veiculoAPI.getTiposVeiculo();
		$scope.resetarFiltro($scope.filtro);
	};

	$scope.filtrar = function (filtro) {
		$scope.veiculos = veiculoAPI.getVeiculos(filtro);
	};

	$scope.getMarcas = function (tipo) {
		$scope.marcas = genericAPI.request('marcas', tipo);
	};

	$scope.getModelos = function (marca) {
		$scope.modelos = genericAPI.request('modelos', marca);
	}

	$scope.resetarFiltro = function (filtro) {
		filtro.tipo   = "";
		filtro.placa  = "";
		filtro.marca  = "";
		filtro.modelo = "";
		$scope.filtrar(filtro);
	}

});