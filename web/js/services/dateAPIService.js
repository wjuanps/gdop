angular.module('gdop').factory('dateAPI', function ($filter) {

	var _dateFormat = function (date) {
		var _datahora = date.split(" ");
		var _data     = _datahora[0].split("/");
		var _hora     = _datahora[1].split(":");
		var _newData  = new Date(_data[2], _data[1]-1, _data[0], _hora[0], _hora[1], 0);

		return $filter('date')(_newData, 'yyyy-MM-dd HH:mm:ss');
	};

	return {
		dateFormat: _dateFormat
	};

});