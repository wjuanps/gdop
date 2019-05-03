angular.module("gdop").factory("chartAPI", function ($filter) {
	var _createBarChart = function (chart) {
		let _config = {
		    type: 'bar',
		    data: {
		        labels: chart.labels,
		        datasets: [{
		            label: chart.label,
		            borderWidth: 0.3,
		            data: chart.data,
		            backgroundColor: chart.backgroundColor,
		            hoverBackgroundColor: chart.hoverBackgroundColor,
		            borderColor: chart.borderColor
		        }]
		    },
		    options: {
		    	showLines: false,
		    	title: {
	                display: false,
	                fontSize: 16
	            },
		    	scales: {
		    		xAxes: [{
		    			display: true,
		    			scaleLabel: {
		    				display: true,
		    				labelString: $filter('name')(chart.element.split("-").pop().concat('s'))
		    			}
		    		}],
		    		yAxes: [{
		    			display: true,
		    			scaleLabel: {
		    				display: true,
		    				labelString: 'Total'
		    			},
		    			ticks: {
		    				beginAtZero: true
		    			}
		    		}],
		    		gridLines: {
						drawOnChartArea: false
					}
		    	}
		    }
		};
		_gerarGrafico(_config, chart.element);
	};

	var _createLineChart = function (chart, lableTitle, labelString) {
		let _config = {
	        type: 'line',
	        data: {
	            labels: chart.labels,
	            datasets: chart.dataSets
	        },
	        options: {
	            responsive: true,
	            title: {
	                display: true,
	                fontSize: 16,
	                text: lableTitle
	            },
	            tooltips: {
	                mode: 'index',
	                intersect: false,
	            },
	            hover: {
	                mode: 'nearest',
	                intersect: true
	            },
	            scales: {
	                xAxes: [{
	                    display: true,
	                    scaleLabel: {
	                        display: true,
	                        labelString: labelString
	                    }
	                }],
	                yAxes: [{
	                    display: true,
	                    scaleLabel: {
	                        display: true,
	                        labelString: 'Total'
	                    }
	                }]
	            }
	        }
	    };
	    _gerarGrafico(_config, 'chart-line');
	};

	var _gerarGrafico = function (config, element) {
    	let _ctx     = document.getElementById(element).getContext('2d');
    	let _myChart = new Chart(_ctx, config);
	};

	return {
		createBarChart:  _createBarChart,
		createLineChart: _createLineChart,
		gerarGrafico:    _gerarGrafico
	};
});