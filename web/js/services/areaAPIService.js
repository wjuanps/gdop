angular.module("gdop").factory("areaAPI", function (gdopAPI, genericAPI) {

	var _getAreas = function () {
		return genericAPI.request('areas', null);
	};

	var _getBairros = function (area) {
		return genericAPI.request('bairros', area);
	};

	return {
		getAreas: _getAreas,
		getBairros: _getBairros
	};

});