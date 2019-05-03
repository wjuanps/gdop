angular.module('gdop').filter('name', function () {
	return function (input) {
		var listaDeNomes = input.split(" ");
		listaDeNomes = listaDeNomes.filter(function (nome) {
			return nome;
		});

		listaDeNomes = listaDeNomes.map(function (nome) {
			if (nome.length <= 3) return nome.toLowerCase();
			return nome.charAt(0).toUpperCase().concat(nome.substring(1).toLowerCase());
		});
		return listaDeNomes.join(" ");
	};
});