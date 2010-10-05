$(document).ready(function(){

    // Mostra il menu al clic col destro su un utente
    $('.collapsible > legend').click(function() {
		if($(this).parent().hasClass('collapsed')) {
			$(this).next().slideDown('slow');
			$(this).parent().removeClass('collapsed');			
		} else {
			$(this).next().slideUp('slow');
			$(this).parent().addClass('collapsed');			
		}
	});

    // Mostra il menu al clic col destro su un utente
    $('fieldset#columns').addClass('collapsed');
	$('fieldset#columns').children('div').hide();
    
});
