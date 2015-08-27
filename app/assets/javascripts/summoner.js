jQuery(function($){

  var donut_options = function(superior){
    var main_color = '#FF9800';
    if (superior) {
      main_color = '#00BCD4';
    }
    var return_options = {
      colors: [
        main_color,
        '#EFEFEF'],
      donut_thickness: '10%',
      full_donut: false,
      rounded: true
    };
    return return_options;
  };


  $('.build_donut').each(function(){
    var user_value = parseFloat($(this).data('user-value'));
    var comparison_value = parseFloat($(this).data('comparison-value'));
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
    var superior = user_value >= comparison_value;
    if ($(this).data('inverse-superiority')) {
      superior = user_value <= comparison_value;
    }
    $(this).drawDonut(donut_data, $.extend(specific_donut_options, donut_options(superior)));
  });

  var line_options = {
      colors: [
          '#00BCD4',
          '#FF9800'],
      has_key: false,
      hover: true
  };

  $('.build_line').each(function(){
    var summoner_name = $(this).data('summoner-name');
    var comparison_title = $(this).data('comparison-title');
    var line_data = [[
      {
        name: summoner_name + " 0-10",
        value: parseFloat($(this).data('user-value-0-10'))
      },{
        name: summoner_name + " 10-20",
        value: parseFloat($(this).data('user-value-10-20'))
      },{
        name: summoner_name + " 20-30",
        value: parseFloat($(this).data('user-value-20-30'))
      },{
        name: summoner_name + " 30-End",
        value: parseFloat($(this).data('user-value-30-end'))
      }],[
      {
        name: comparison_title + " 0-10",
        value: parseFloat($(this).data('comparison-value-0-10'))
      },{
        name: comparison_title + " 10-20",
        value: parseFloat($(this).data('comparison-value-10-20'))
      },{
        name: comparison_title + " 20-30",
        value: parseFloat($(this).data('comparison-value-20-30'))
      },{
        name: comparison_title + " 30-End",
        value: parseFloat($(this).data('comparison-value-30-end'))
      }
      ]
    ];
    var specific_line_options = {
      title: $(this).data('chart-title')
    };
    $(this).drawLine(line_data, $.extend(specific_line_options, line_options));
  });


});
