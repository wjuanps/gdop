angular.module('gdop').filter('ellipsis', function () {
	return function (input, length) {
		if (input.length <= length) return input;
		var _output = input.substring(0, (length || 5)) + "...";
		return _output;
	};
});