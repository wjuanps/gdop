angular.module('gdop').factory('sessionAPI', function (gdopAPI) {

	var _addOnSession = function (name, object) {
		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/services/requestSession.php',
			{option: 'add', object: object, name: name}
		).then(
			function successCallback(response) {
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
	};

	return {
		addOnSession: _addOnSession
	};

});