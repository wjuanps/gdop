angular.module("gdop").config(function ($httpProvider) {
	$httpProvider.interceptors.push("loadingInterceptor");
});