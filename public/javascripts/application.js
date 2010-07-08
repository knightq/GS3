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

var request = function(options){
    $.ajax($.extend({
        url: options.url,
        type: 'get'
    }, options));
    return false;
};

$(document).ready(function(){
    dock();
    
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
    
    $(".gruppo_head").toggle(function(){
        $(this).parent().addClass("opened");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    }, function(){
        $(this).parent().removeClass("opened");
        $(this).parent().children('.segnalazioni_container').slideToggle(1000);
    });
    $(".segnalazioni_container").hide();
	
});

