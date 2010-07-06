// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var hideFlashes = function(){
    $("#flash_notice, #flash_error").fadeOut(800);
    $("#flash_messages").slideUp(800);
}

function dock(){
    var dock = new MacStyleDock(document.getElementById('dock'), [{
        name: 'images/todo',
        extension: '.png',
        sizes: [32, 48],
        onclick: function(){
            window.location = '/todo';
        }
    }, {
        name: 'images/users',
        extension: '.png',
        sizes: [32, 48],
        onclick: function(){
            window.location = '/utenti';
        }
    }, {
        name: 'images/statistiche',
        extension: '.png',
        sizes: [32, 48],
        onclick: function(){
            window.location = '/statistiche';
        }
    }], 32, 48, 3);
}

$(document).ready(function(){
    dock();

	$('a.anchor_to').click(function() {
		$('html body').scrollTo( $(this).attr("href"), 800 );
		return false;
	});

    setTimeout(hideFlashes, 1000);
    
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
    
    //Hide (Collapse) segnalazioni_container on load
    $(".gruppi_container").hide();
    $(".segnalazioni_container").hide();
    $(".versione").children('#versione_ore').hide();
    
    //Switch the "Open" and "Close" state per click
    $("legend.trigger").toggle(function(){
        $(this).parent().addClass("closed");
    }, function(){
        $(this).parent().removeClass("closed");
    });
    
    //Slide up and down on click
    $("legend.trigger").click(function(){
        $(this).parent().children(':not(legend)').slideToggle("slow");
    });
    
    //Slide up and down on click
    $(".collapse_btn").click(function(){
        $(this).next('.collapsible').slideToggle("slow");
    });
    
    $(".hide_btn").click(function(){
        $(this).parent().parent().hide();
    });
    
    //Switch the "Open" and "Close" state per hover
    $(".versione").toggle(function(){
        $(this).addClass("opened");
        $(this).children('.gruppi_container').slideToggle(1000);
    }, function(){
        $(this).removeClass("opened");
        $(this).children('.gruppi_container').slideToggle(1000);
    });
    
    $("div.gruppi_container").toggle(function(){
        $(this).addClass("closed");
        $(this).children('.gruppo').slideToggle(1000);
    }, function(){
        $(this).removeClass("closed");
        $(this).children('.gruppo').slideToggle(1000);
    });
    
    $(".group_name").toggle(function(){
        $(this).parent().addClass("closed");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    }, function(){
        $(this).parent().removeClass("closed");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    });
    
    //Slide up and down on click
    $(".versione").mouseover(function(){
        if (!$(this).is('.closed')) {
            $(this).children('#versione_ore').slideToggle(100);
        }
    });
    $(".versione").mouseout(function(){
        if (!$(this).is('.closed')) {
            $(this).children('#versione_ore').slideToggle(100);
        }
    });
    
});

