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

});
