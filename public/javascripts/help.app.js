$(document).ready(function(){
    $('#toolbox-help').click(function(){
        var helpInfo = new Array();
        $('.help-context').each(function(){
            var item = {
                pos: {
                    x: $(this).offset().left,
                    y: $(this).offset().top,
                    xx: $(this).offset().left + $(this).width(),
                    yy: $(this).offset().top + $(this).height()
                },
                content: $(this).attr('helpId')
            };
            helpInfo.push(item);
        });
        
        $('#toolbox-help').data('helpInfo', helpInfo);
        
        $('body').append('<div id="hover-help"></div>');
        $('#hover-help').css('cursor', 'help');
        
		$('.help-context').addClass('highlight-help');

        $('#hover-help').click(function(e){
            $('#hover-help').css('cursor', 'normal');
            $('#hover-help').remove();
            
            var posX = e.pageX;
            var posY = e.pageY;
			var contentKey = getHelp(document.location.pathname, posX, posY);
            
            $.get('/help/help.' + contentKey + '.html', {}, function(data){
                var popup = $('<div style="display: none; background-color: white; border: solid 1px silver; padding: 4px; position: absolute; top:' + posY + 'px;left:' + posX + 'px; font-size: 0.8em; z-index: 9000;">' + data + '</div>"');
                $('body').append(popup);
                $(popup).show(500).click(function(e){
					$(popup).fadeOut(500);
				});
				$('.help-context').removeClass('highlight-help');
            });
			$('.help-context').removeClass('highlight-help');
        });
    });
});


function getHelp(url, x, y){
    var page = 'any';
    var message_key = 'help_not_found';
    
    var helpInfo = $('#toolbox-help').data('helpInfo');
            
    if (helpInfo != null) {
        for (var i = 0; i < helpInfo.length; i++) {
            element = helpInfo[i];
			if (x >= element.pos.x && y >= element.pos.y &&
            x <= element.pos.xx &&
            y <= element.pos.yy) {
                message_key = element.content;
            }
        }
    }
    
    return message_key;
}
