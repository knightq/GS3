/**
 * @author asalicetti
 */
function add_filter() {
    select = $('#add_filter_select :selected');
    field = select.val()
    check_box = $('#cb_' + field);
	check_box.attr('checked', true);
	$('#tr_' +  field).show();
    toggle_filter(field);
	select.attr('disabled', 'true');
	select.removeAttr('selected');
	select.parent().children(':first').attr("selected", "selected");
}

function toggle_filter(field) {
    check_box = $('#cb_' + field);
	if (check_box.attr('checked')) {
        $("#operators_" + field).show();
        toggle_operator(field);
    } else {
        $("#operators_" + field).hide();
        $("#div_values_" + field).hide();
		check_box.parent().parent().hide();
		id = check_box.attr('value');
		option = $('#add_filter_select').children('option[value=' + id +']')
		option.removeAttr('disabled');
  }
}

function toggle_operator(field) {
  operator = $("#operators_" + field);
  /*alert("Operator: " + operator + ", value: " + operator.val());*/
  switch (operator.val()) {
    case "!*":
    case "*":
    case "t":
    case "w":
    case "o":
    case "c":
      $("#div_values_" + field).hide();
      break;
    default:
      $("#div_values_" + field).show();
      break;
  }
}

function toggle_multi_select(field) {
    select = $('#values_' + field);
    if (select.attr('multiple')) {
        select.removeAttr('multiple');
    } else {
        select.attr('multiple', 'true');
    }
}

$(document).ready(function(){
	apply_filters_observer();
});