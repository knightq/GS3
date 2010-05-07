// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	setTimeout(hideFlashes, 1000);
});

var hideFlashes = function() {
  $("#flash_notice, #flash_error").fadeOut(800);
	$("#flash_messages").slideUp(800);
}

$(document).ready(function(){

	$(function () {
		$('.bubbleInfo').each(function () {
		  // options
		  var distance = 5;
		  var time = 150;
		  var hideDelay = 200;

		  var hideDelayTimer = null;

		  // tracker
		  var beingShown = false;
		  var shown = false;
		  
		  var trigger = $('.trigger', this);
		  var popup = $('.popup', this).css('opacity', 0);

		  // set the mouseover and mouseout on both element
		  $([trigger.get(0), popup.get(0)]).mouseover(function () {
		    // stops the hide event if we move from the trigger to the popup element
		    if (hideDelayTimer) clearTimeout(hideDelayTimer);

		    // don't trigger the animation again if we're being shown, or already visible
		    if (beingShown || shown) {
		      return;
		    } else {
		      beingShown = true;

		      // reset position of popup box
		      popup.css({
		        top: -45,
		        left: 100,
		        display: 'block' // brings the popup back in to view
		      })

		      // (we're using chaining on the popup) now animate it's opacity and position
		      .animate({
		        top: '-=' + distance + 'px',
		        opacity: 1
		      }, time, 'swing', function() {
		        // once the animation is complete, set the tracker variables
		        beingShown = false;
		        shown = true;
		      });
		    }
		  }).mouseout(function () {
		    // reset the timer if we get fired again - avoids double animations
		    if (hideDelayTimer) clearTimeout(hideDelayTimer);
		    
		    // store the timer so that it can be cleared in the mouseover if required
		    hideDelayTimer = setTimeout(function () {
		      hideDelayTimer = null;
		      popup.animate({
		        top: '-=' + distance + 'px',
		        opacity: 0
		      }, time, 'swing', function () {
		        // once the animate is complete, set the tracker variables
		        shown = false;
		        // hide the popup entirely after the effect (opacity alone doesn't do the job)
		        popup.css('display', 'none');
		      });
		    }, hideDelay);
		  });
		});
	});

		$('.collapse_all').click(function(){
			$(this).nextAll('div').children('.collapsible').slideUp('slow');
		});
		$('.expand_all').click(function(){
			$(this).nextAll('div').children('.collapsible').slideDown('slow');
		});

	//Show the toggle containers on load
	$(".toggle_container").show(); 
	//Hide (Collapse) segnalazioni on load
//	$(".segnalazioni").hide();
	//Hide (Collapse) segnalazioni_container on load
	$(".segnalazioni_container").hide();
	$(".versione").children('#versione_ore').hide();

	//Switch the "Open" and "Close" state per click
	$("legend.trigger").toggle(function(){
		$(this).parent().addClass("closed");
		}, function () {
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
	$("div.versione").toggle(function(){
		$(this).addClass("closed");
		$(this).next('.segnalazioni_container').slideToggle(1000);
		}, function () {
		$(this).removeClass("closed");
		$(this).next('.segnalazioni_container').slideToggle(1000);
	});

	//Slide up and down on click
	$("div.versione").mouseover(function(){
		if (!$(this).is('.closed')) {
			$(this).children('#versione_ore').slideToggle(100);
		}
	});
	$("div.versione").mouseout(function(){
		if (!$(this).is('.closed')) {
			$(this).children('#versione_ore').slideToggle(100);
		}
	});

$(".drag")
        .bind( "dragstart", function( event ){
                // ref the "dragged" element, make a copy
                var $drag = $( this ), $proxy = $drag.clone();
                // modify the "dragged" source element
                $drag.addClass("outline");
                // insert and return the "proxy" element                
                return $proxy.appendTo( document.body ).addClass("ghost");
                })
        .bind( "drag", function( event ){
                // update the "proxy" element position
                $( event.dragProxy ).css({
                        left: event.offsetX,
                        top: event.offsetY
                        });
                })
        .bind( "dragend", function( event ){
                // remove the "proxy" element
                $( event.dragProxy ).fadeOut( "normal", function(){
                        $( this ).remove();
                        });
                // if there is no drop AND the target was previously dropped
                if ( !event.dropTarget && $(this).parent().is(".drop") ){
                        // output details of the action
                        $('#log').append('<div>Removed <b>'+ this.title +'</b> from <b>'+ this.parentNode.title +'</b></div>');
                        // put it in it's original div...
                        $('#nodrop').append( this );
                        }
                // restore to a normal state
                $( this ).removeClass("outline");      
               
                });
$(".drop")
        .bind( "dropstart", function( event ){
                // don't drop in itself
                if ( this == event.dragTarget.parentNode ) return false;
                // activate the "drop" target element
                $( this ).addClass("active");
                })
        .bind( "drop", function( event ){
                // if there was a drop, move some data...
                $( this ).append( event.dragTarget );
                // output details of the action...
                $('#log').append('<div>Dropped <b>'+ event.dragTarget.title +'</b> into <b>'+ this.title +'</b></div>');        
								alert('Presa in carico!')                
								})
        .bind( "dropend", function( event ){
                // deactivate the "drop" target element
                $( this ).removeClass("active");
                });
});

