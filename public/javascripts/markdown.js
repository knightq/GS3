$().ready(function(){
	
	$('.wmd-preview').click(function(){
	    $(this).addClass('anteprima');
		$(this).prev().slideDown(800, function(){
	        $(this).prev().children('textarea')[0].focus();
	    });
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

});
