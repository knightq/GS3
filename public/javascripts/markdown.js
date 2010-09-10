$().ready(function(){
	
	$('.wmd-preview').click(function(){
	    if($(this).hasClass('anteprima')) {
			form = $(this).parent()
			form.reset();
	        form.slideUp(800, function() {
	    		$(this).hide();
		  	});
			form.next().removeClass('anteprima');
		} else {
			$(this).addClass('anteprima');
			$(this).prev().slideDown(800, function(){
				txtArea = $(this).prev().children('textarea')[0];
				if(typeof txtArea != "undefined") {
					txtArea.focus();
				}
		    });
		}
	});

	$('.save_btn').click(function () {
		form = $(this).parent()
		form.submit();
        form.slideUp(800, function() {
    		$(this).hide();
	  	});
		form.next().removeClass('anteprima');
		return false;
	});

	$('.cancel_btn').click(function () {
		form = $(this).parent()
		form.reset();
		form.slideUp(800, function() {
    		$(this).hide();
	  	});
		form.next().removeClass('anteprima');
		return false;
	});
});
