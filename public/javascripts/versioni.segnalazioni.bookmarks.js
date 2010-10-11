$(document).ready(function(){
    $("ul.versioni > li").toggle(function() {
		version_id = $(this).children('a').attr('version_id');
		$('h3#version_' +version_id+'_header').fadeOut("slow");
		$('div#version_' +version_id+'_container').fadeOut("slow");
		$(this).attr('class', 'unchecked');
	}, function() {
		version_id = $(this).children('a').attr('version_id');
		$('h3#version_' +version_id+'_header').fadeIn("slow");
		$('div#version_' +version_id+'_container').fadeIn("slow");
		$(this).attr('class', 'checked');
	});

});
