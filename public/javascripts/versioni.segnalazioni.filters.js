$(document).ready(function(){
    $("span#show_closed").parent().toggle(function() {
		$('li.closed').fadeOut("slow");
		$(this).attr('class', 'unchecked');
	}, function() {
		$('li.closed').fadeIn("slow");
		$(this).attr('class', 'checked');
	});

    $("span#show_done").parent().toggle(function() {
		$('li.done').fadeOut("slow");
		$(this).attr('class', 'unchecked');
	}, function() {
		$('li.done').fadeIn("slow");
		$(this).attr('class', 'checked');
	});

    $("span#show_todo").parent().toggle(function() {
		$('li.todo').fadeOut("slow");
		$(this).attr('class', 'unchecked');
	}, function() {
		$('li.todo').fadeIn("slow");
		$(this).attr('class', 'checked');
	});

    $("span#show_wait").parent().toggle(function() {
		$('li.wait').fadeOut("slow");
		$(this).attr('class', 'unchecked');
	}, function() {
		$('li.wait').fadeIn("slow");
		$(this).attr('class', 'checked');
	});

});
