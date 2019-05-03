angular.module("gdop").controller("consultaOcorrenciaCtrl", function ($scope, ocorrenciaAPI, sessionAPI, chartAPI, gdopAPI) {

	$scope.filtrar = function (filtro) {
		$scope.ocorrencias = ocorrenciaAPI.getOcorrencias(filtro);
	};

	$scope.detalharOcorrencia = function (codigo) {
		$scope.ocorrenciaCompleta = ocorrenciaAPI.getOcorrencia(codigo);
	};

	$scope.editarOcorrencia = function (codigoOcorrencia) {
		sessionAPI.addOnSession('editarOcorrencia', codigoOcorrencia);
		location.href = '/gdop/editar-ocorrencia';
	};
});