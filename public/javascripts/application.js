// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults


var hideFlashes = function(){
    $("#flash_notice, #flash_error").fadeOut(800);
    $("#flash_messages").slideUp(800);
}

var showFlashes = function(){
	$("#flash_notice, #flash_error").show();
    $("#flash_notice, #flash_error").fadeIn(800);
    $("#flash_messages").slideDown(800);
}

var request = function(options){
    $.ajax($.extend({
        url: options.url,
        type: 'get'
    }, options));
    return false;
};

$(document).ready(function(){
	/*var elems = ["c++", "java", "php", "coldfusion", "javascript", "asp", "ruby", "python", "c", "scala", "groovy", "haskell", "pearl"];*/
	$("#input_gs_quick_search").autocomplete("gsprg", {
		width: 80,
		selectFirst: false,
	 	extraParams: {
		 	user_id:function() {
			 	if($('#myonly').is(':checked')) {
					return $('#user_id').val()
		     	} else {
					return -1
				}
	        }
		}
	}).result(function(event, item) {
  		location.href = 'segnalazioni/' + item;
	});
	$("#input_gs_quick_search").result(function(event, data, formatted) {
		if (data)
			$(this).parent().next().find("input").val(data[1]);
	});


	setTimeout(hideFlashes, 1000);
    
    // remote links handler
    $('a[data-remote=true]').live('click', function(){
        return request({
            url: this.href
        });
    });
    
    // remote forms handler
    $('form[data-remote=true]').live('submit', function(){
        return request({
            url: this.action,
            type: this.method,
            data: $(this).serialize()
        });
    });
    
    $('a.anchor_to').click(function(){
        $('html body').scrollTo($(this).attr("href"), 800);
        return false;
    });
        
    if ($(".dynamic_sidebar_content > div").size() > 0) {
        $('.sidebar_tools').show()
    }
    else {
        $('.sidebar_tools').hide()
    }
    
    $('.collapse_all').click(function(){
        $('.dynamic_sidebar_content').children('div').children('.collapsible').slideUp('slow');
    });
    $('.expand_all').click(function(){
        $('.dynamic_sidebar_content').children('div').children('.collapsible').slideDown('slow');
    });
    
    $('.sidebar_toggler').toggle(function(){
        $('#sidebar').removeClass('sidebar_opened').addClass('sidebar_closed');
        $('#sidebar').animate({
            width: "0%"
        }, 1500, function(){
            // Animation complete.
            $('.sidebar_toggler').removeClass('hide_sidebar').addClass('show_sidebar');
            $('.sidebar_toggler').attr('title', 'Mostra la barra degli strumenti');
        });
        $('#content').animate({
            width: "98%",
            'padding-left': "2%"
        }, 1500);
        $('.sidebar_tools').animate({
            opacity: "0"
        }, 750, function(){
            // Animation complete.
            $('.sidebar_tools').hide();
        });
        $('.dynamic_sidebar_content').animate({
            opacity: "0"
        }, 750, function(){
            // Animation complete.
            $('.dynamic_sidebar_content').hide();
        });
    }, function(){
        $('.sidebar_toggler').removeClass('show_sidebar').addClass('hide_sidebar');
        $('.sidebar_toggler').attr('title', 'Nascondi la barra degli strumenti');
        $('#sidebar').animate({
            width: "30%"
        }, 1500, function(){
            $(this).removeClass('sidebar_closed').addClass('sidebar_opened');
        });
        $('#content').animate({
            width: "70%",
            'padding-left': "360px"
        }, 1500);
        $('.sidebar_tools').animate({
            opacity: "100"
        }, 750, function(){
            // Animation complete.
            $('.sidebar_tools').show();
        });
        $('.dynamic_sidebar_content').show();
        $('.dynamic_sidebar_content').animate({
            opacity: "100"
        }, 750);
    });

    // Collapse dei widget della toolbar
    $(".collapse_btn").click(function(){
        $(this).next('.collapsible').slideToggle("slow");
    });

    $(".hide_btn").click(function(){
        $(this).parent().parent().hide();
    });
    

    
    //Switch "Prodotto"
    $("legend.trigger").toggle(function(){
        $(this).parent().addClass("closed");
        $(this).parent().children(':not(legend)').slideToggle("slow");
    }, function(){
        $(this).parent().removeClass("closed");
        $(this).parent().children(':not(legend)').slideToggle("slow");
    });

    //Switch "Versione"
    $(".versione_head").toggle(function(){
        $(this).parent().addClass("opened");
        $(this).parent().children('.gruppi_container').slideToggle(1000);
    }, function(){
        $(this).parent().removeClass("opened");
        $(this).parent().children('.gruppi_container').slideToggle(1000);
    });
    $(".gruppi_container").hide();
	// Aperta la corrente
	$(".corrente").parent().parent().parent().next().show();
	$(".corrente").parent().parent().parent().parent().addClass("opened");
    
    $(".gruppo_head").toggle(function(){
        $(this).parent().addClass("opened");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    }, function(){
        $(this).parent().removeClass("opened");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    });
    $(".segnalazioni_container").hide();
	
});

function toggleIssuesSelection(el) {
	var boxes = el.getElementsBySelector('input[type=checkbox]');
	var all_checked = true;
	for (i = 0; i < boxes.length; i++) { if (boxes[i].checked == false) { all_checked = false; } }
	for (i = 0; i < boxes.length; i++) {
		if (all_checked) {
			boxes[i].checked = false;
			boxes[i].up('tr').removeClassName('context-menu-selection');
		} else if (boxes[i].checked == false) {
			boxes[i].checked = true;
			boxes[i].up('tr').addClassName('context-menu-selection');
		}
	}
}
