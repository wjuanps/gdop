angular.module('gdop').factory('filtroOcorrenciaAPI', function (dateAPI, $filter) {

	var _prepararFiltro = function (filtro) {
		try {
			var _filtro = angular.copy(filtro);
			var _dataExperada = /^\d{2}\/\d{2}\/\d{4}\s\d{2}:\d{2}$/;
			if (!_filtro.dataInicial || !_dataExperada.test(_filtro.dataInicial)) {
				_filtro.dataInicial = dateAPI.dateFormat("01/01/1970 00:00");
			}

			if (!_filtro.dataFinal || !_dataExperada.test(_filtro.dataFinal)) {
				_filtro.dataFinal = dateAPI.dateFormat($filter('date')(new Date(), 'dd/MM/yyyy HH:mm'));
			}

			let _anoEsperado = /^\d{4}$/;
			if (!_filtro.anoPeriodo || !_anoEsperado.test(_filtro.anoPeriodo)) {
				_filtro.anoPeriodo = $filter('date')(new Date(), 'yyyy');
			}

			_filtro.area = (_filtro.area === "Castanhal") ? "" : _filtro.area;

			return _filtro;
			
		} catch (e) {
			console.log(e);
		}
	};

	return {
		prepararFiltro: _prepararFiltro
	};

});