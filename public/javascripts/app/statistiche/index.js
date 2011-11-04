$(document).ready(function() {
	hint = $('img.hint_img');
	var text = hint.attr('data-text');
	hint.qtip({
		content: text
	});
});