$(document).ready(function(){

    // Mostra il menu al clic col destro su un utente
    $('.collapsible > legend').toggle(function() {
		$(this).next().slideUp('slow');
		$(this).parent().addClass('collapsed');
	}, function() {
		$(this).next().slideDown('slow');
		$(this).parent().removeClass('collapsed');
	});
    
});
