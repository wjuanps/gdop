angular.module("gdop").factory("loadingInterceptor", function ($q, $rootScope) {
	return {
		request: function (config) {
			$rootScope.loading = (config.url.indexOf('requests.php') <= 0);
			return config;
		},
		requestError: function (rejection) {
			$rootScope.loading = false;
			return $q.reject(rejection);
		},
		response: function (response) {
			$rootScope.loading = false;
			return response;
		},
		responseError: function (rejection) {
			$rootScope.loading = false;
			return $q.reject(rejection);
		}
	};
});