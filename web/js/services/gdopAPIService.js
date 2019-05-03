angular.module("gdop").factory("gdopAPI", function ($http, $httpParamSerializer) {
	var _ajaxPost = function (url, data) {
		return $http({
			method: 'POST',
			url: url,
			data: $httpParamSerializer(data),
			headers: {'Content-type': 'application/x-www-form-urlencoded'}
		});
	};

	var _ajaxGet = function (url, params) {
		return $http({
			method: 'GET',
			url: url,
			params: params
		});
	};

	return {
		ajaxPost: _ajaxPost,
		ajaxGet: _ajaxGet
	};
});