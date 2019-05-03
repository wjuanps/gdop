angular.module("gdop").controller("cadastroOcorrenciaCtrl", function ($scope, envolvidoAPI, genericAPI, veiculoAPI, ocorrenciaAPI, areaAPI, gdopAPI, $filter) {
	
	$scope.showAlertEnvovido = false;
	$scope.showAlertVeiculo  = false;

	$scope.ocorrencia = {
		envolvidos: [],
		veiculos: [],
		itensRoubo: [{item: "", quantidade: 0}],
		informacoesComplementares: "",
		descricao: "",
		trote: false
	};

	$scope.dados = {
		tiposVeiculo: {}, 
		tiposOcorrencia: {}, 
		marcas: {}, 
		modelos: {}, 
		areas: {}, 
		bairros: {}, 
		veiculos: [],
		itensRoubo: [],
		coresVeiculos: [],
		tiposEnvolvidos: []
	};

	$scope.init = function () {
		try {
			$scope.dados['tiposOcorrencia'] = ocorrenciaAPI.getTiposOcorrencia();
			$scope.dados['areas'] = areaAPI.getAreas();
		} catch (e) {
			console.log(e);
		}

		gdopAPI.ajaxPost(
			'src/com/wjuan/gdop/services/requestSession.php',
			{option: 'get', name: 'editarOcorrencia', retorno: 'ocorrencia'}
		).then(
			function successCallback(response) {
				try {
					var _ocorrencia = angular.copy(response.data);
					$scope.showVeiculo = !!_ocorrencia.veiculos.length;
					$scope.showOutros  = !!_ocorrencia.itensRoubo.length;
					$scope.area = _ocorrencia.bairro.area.nome;
					$scope.change('itensRoubo', null);
					$scope.change('bairros', _ocorrencia.bairro.area.nome);
					$scope.setFurtoRoubo(_ocorrencia.tipo);
					$scope.ocorrencia = _ocorrencia;
					$scope.ocorrencia.bairro = _ocorrencia.bairro.nome;
					$scope.disabled = true;
				} catch (e) {
					
				}
			},
			function errorCallback(response) {
				console.log(response);
			}
		);
	};

	$scope.change = function (option, arg) {
		$scope.dados[option] = genericAPI.request(option, arg);
		$scope.showAlertVeiculo = (option === "veiculos");
		$scope.toggleItensRoubo($scope.ocorrencia.itensRoubo);
	};

	var _isEnvolvido = false;
	$scope.initEnvolvidos = function () {
		$scope.limparCampos();
		if (!_isEnvolvido) {
			$scope.dados['tiposEnvolvidos'] = envolvidoAPI.getTiposEnvolvido();
			_isEnvolvido = true;
		}
	};

	$scope.pesquisarEnvolvido = function (event, nomeEnvolvido) {
		if (!!nomeEnvolvido && (event == null || event.keyCode === 13)) {
			$scope.envolvidos = envolvidoAPI.getEnvolvidos(nomeEnvolvido).envolvidos;
			$scope.showAlertEnvovido = true;
			_disabled();
		}
	};

	$scope.selecionarEnvolvido = function (envolvido) {
		$scope.envolvido = envolvido;
		$scope.envolvido.dataNascimento = $filter('date')($scope.envolvido.dataNascimento, 'dd/MM/yyyy');
		delete $scope.nomeEnvolvido;
		$scope.envolvidos = [];
		$scope.showAlertEnvovido = false;
	};

	$scope.adicionarEnvolvido = function (envolvido) {
		try {
			var _dateArray = envolvido.dataNascimento.split("/");
			envolvido.dataNascimento = $filter('date')(new Date(_dateArray[2], _dateArray[1]-1, _dateArray[0]), 'yyyy-MM-dd');
			if (!envolvido.codigo) {
				envolvido = envolvidoAPI.cadastrarEnvolvido(envolvido);
			}
			$scope.ocorrencia.envolvidos.push(envolvido);
			delete $scope.envolvido;
			$scope.formEnvolvido.$setPristine();
			_disabled();
		} catch (e) {}
	};

	$scope.removerEnvolvido = function (envolvido) {
		var _index = $scope.ocorrencia.envolvidos.indexOf(envolvido);
		$scope.ocorrencia.envolvidos.splice(_index, 1);
		_disabled();
	};

	var _isVeiculo = false;
	$scope.initVeiculo = function () {
		if (!_isVeiculo) {
			$scope.dados['tiposVeiculo']  = veiculoAPI.getTiposVeiculo();
			$scope.dados['coresVeiculos'] = veiculoAPI.getCoresVeiculos();
			_isVeiculo = true;
		}
	};

	$scope.pesquisarVeiculo = function (event, placa) {
		if (placa && (event == null || event.keyCode === 13)) {
			$scope.change('veiculos', placa);
		}
	};

	$scope.adicionarVeiculo = function (veiculo) {
		$scope.ocorrencia.veiculos.push(veiculo);
		delete $scope.veiculo;
		delete $scope.placaVeiculo;
		$scope.dados['veiculos'] = [];
		$scope.formVeiculo.$setPristine();
		$scope.showAlertVeiculo = false;
		_disabled();
	};

	$scope.cadastrarVeiculo = function (veiculo) {
		$scope.ocorrencia.veiculos.push(veiculoAPI.cadastrarVeiculo(veiculo));
		delete $scope.veiculo;
		$scope.formVeiculo.$setPristine();
		$scope.showAlertVeiculo = false;
		_disabled();
	};

	$scope.removerVeiculo = function (veiculo) {
		var _index = $scope.ocorrencia.veiculos.indexOf(veiculo);
		$scope.ocorrencia.veiculos.splice(_index, 1);
		_disabled();
	};

	$scope.limparCampos = function () {
		try {
			delete $scope.veiculo;
			delete $scope.envolvido;
			$scope.dados['veiculos'] = [];
			$scope.envolvidos = [];
			$scope.showAlertEnvovido = false;
			$scope.showAlertVeiculo = false;
			delete $scope.placaVeiculo;
			delete $scope.nomeEnvolvido;
			$scope.formEnvolvido.$setPristine();
			$scope.formVeiculo.$setPristine();
			_disabled();
		} catch (e) {
			console.log(e);
		}
	};

	$scope.setFurtoRoubo = function(furtoRoubo) {
		$scope.isFurtoRoubo = /(Furto|Roubo|Latrocínio)/.test(furtoRoubo);
		$scope.toggleItensRoubo($scope.ocorrencia.itensRoubo);
	};

	$scope.adicionarItemRoubo = function (itemRoubado) {
		$scope.ocorrencia.itensRoubo.push(itemRoubado);
		$scope.toggleItensRoubo($scope.ocorrencia.itensRoubo);
	};

	$scope.removerItemRoubo = function (item, itens) {
		if (itens.length === 1) {
			$scope.ocorrencia.itensRoubo = [{item: "", quantidade: 0}];
		} else {
			var _index = itens.indexOf(item);
			$scope.ocorrencia.itensRoubo.splice(_index, 1);
		}
		$scope.toggleItensRoubo($scope.ocorrencia.itensRoubo);
	};

	var _isItensRoubados = false;
	$scope.removerItensRoubados = function (showOutros) {
		if (!_isItensRoubados) {
			$scope.dados['itensRoubo'] = genericAPI.request('itensRoubo', null);
			_isItensRoubados = true;
		}

		if (!showOutros) {
			$scope.ocorrencia.itensRoubo = [{item: "", quantidade: 0}];
		}
		$scope.showOutros = showOutros;
		$scope.toggleItensRoubo($scope.ocorrencia.itensRoubo);
	};

	$scope.removerVeiculos = function (showVeiculo) {
		if (!showVeiculo) {
			$scope.ocorrencia.veiculos = [];
		}
		$scope.showVeiculo = showVeiculo;
		_disabled();
	};

	$scope.cadastrarOcorrencia = function (ocorrencia) {
		var _arg = (!ocorrencia.codigo) ? "cadastrar" : "atualizar";
		$scope.message = (_arg === 'cadastrar') ? "Cadastro realizado com sucesso!!" : "Atualização realizada com sucesso!!";
		$scope.ocorrencia = ocorrenciaAPI.cadastrarOcorrencia(ocorrencia, _arg);
	};

	$scope.toggleItensRoubo = function (itensRoubo) {
		if (itensRoubo.length) {
			$scope.hasItensRoubados = itensRoubo.some(function (elemento) {
				return elemento.item && elemento.quantidade;
			});
		}
		_disabled();
	};

	$scope.keyUp = function () {
		_disabled();
	};

	$scope.redirect = function () {
		location.href = '/gdop/';
	};

	var _disabled = function () {
		$scope.disabled = (
			!$scope.formOcorrencia.$invalid && !!$scope.ocorrencia.envolvidos.length && (($scope.isFurtoRoubo) ? (
				(($scope.showVeiculo && $scope.showOutros) ? 
					(!!$scope.ocorrencia.veiculos.length && $scope.hasItensRoubados) : 
						(($scope.showVeiculo) ? (
							!!$scope.ocorrencia.veiculos.length
						) : ($scope.showOutros) ? $scope.hasItensRoubados : false)
					)
			) : true)
		);
	};
});