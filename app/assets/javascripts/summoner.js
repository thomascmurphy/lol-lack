jQuery(function($){

  var donut_options = {
    colors: [
      '#00BCD4',
      '#FF9800'],
    donut_thickness: '10%',
    full_donut: false,
    rounded: true
  };

  $('.build_donut').each(function(){
    var user_value = $(this).data('user-value');
    var comparison_value = $(this).data('comparison-value');
    var donut_data = [{
      name: $(this).data('summoner-name'),
      value: user_value
    }];
    var specific_donut_options = {
      title: $(this).data('chart-title'),
      goal_value: user_value + comparison_value,
      goal_value_text: $(this).data('comparison-title'),
      number_decorator: $(this).data('number-decorator')
    };
    $(this).drawDonut(donut_data, $.extend(specific_donut_options, donut_options));
  });

  $('.build_line').each(function(){
    var summoner_name = $(this).data('summoner-name');
    var comparison_title = $(this).data('comparison-title');
    var line_data = [[
      {
        name: summoner_name + " 0-10",
        value: $(this).data('user-value-0-10')
      },{
        name: summoner_name + " 10-20",
        value: $(this).data('user-value-10-20')
      },{
        name: summoner_name + " 20-30",
        value: $(this).data('user-value-20-30')
      },{
        name: summoner_name + " 30-End",
        value: $(this).data('user-value-30-end')
      }],[
      {
        name: comparison_title + " 0-10",
        value: $(this).data('comparison-value-0-10')
      },{
        name: comparison_title + " 10-20",
        value: $(this).data('comparison-value-10-20')
      },{
        name: comparison_title + " 20-30",
        value: $(this).data('comparison-value-20-30')
      },{
        name: comparison_title + " 30-End",
        value: $(this).data('comparison-value-30-end')
      }
      ]
    ];
    var specific_line_options = {
      title: $(this).data('chart-title'),
      hover: true
    };
    $(this).drawLine(line_data, $.extend(specific_line_options, donut_options));
  });


var line_values = [
    [{
        name: 'Item 1',
        value: 2,
        tooltip_value: ['CSS', 'HTML']
    }, {
        name: 'Item 2',
        value: 3,
        tooltip_value: ['Python']
    }, {
        name: 'Item 3',
        value: 5,
        tooltip_value: ['Ruby', 'SQL']
    }, {
        name: 'Item 4',
        value: 7,
        tooltip_value: ['PostGreSQL', 'JQuery']
    }, {
        name: 'Item 5',
        value: 10,
        tooltip_value: ['Mongo', 'HTML', 'Rails']
    }]
];

var line_options = {
    colors: [
        '#4CAF50',
        '#FBC02D'],
    has_key: false,
    hover: true,
    title: 'Job Timeline'
};

$('#line_chart').drawLine(line_values, line_options);

});
