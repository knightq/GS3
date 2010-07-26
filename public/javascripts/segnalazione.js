$().ready(function(){
	$('#s_edit').hide();

	$('blockquote').after('<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" width="110" height="14" id="clippy" ><param name="movie" value="/swf/clippy.swf"/><param name="allowScriptAccess" value="always" /><param name="quality" value="high" /><param name="scale" value="noscale" /><param NAME="FlashVars" value="text=' + $(this).children().text() +'"><param name="bgcolor" value="#fff"><embed src="/swf/clippy.swf" width="110" height="14" name="clippy" quality="high" allowScriptAccess="always" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" FlashVars="text=' + $(this).children().text() +' bgcolor="#fff" /></object>');
	
	$('.wmd-preview').click(function () {
		 $(this).addClass('anteprima');
         $('#s_edit').slideDown(800, function() {
			$('#s_des_segna').focus();
	  	});
    });

	$('#save_btn').click(function () {
		 $('.wmd-preview').removeClass('anteprima');
         $('#s_edit').slideUp(800, function() {
    		$(this).hide();
	  	});
	});

    $('.wiz-container').smartWizard({
        selectedStep: $('#lastWiz').attr('value'),
        validatorFunc: validateTabs
    });
	
	$('#save_btn').click(function(){
		$('#s_edit').submit();
		return false;
    });

	if ($('#lastWiz').attr('value') == 4) {
		$('wiz-nav').hide();
	}
});

function validateTabs(tabIdx){
    ret = true;
    switch (tabIdx) {
        case 0:
			cliente = document.getElementById("cda_cliente");
			prodotto = document.getElementsByClassName("segnalazione_cod_prodotto");
			segnalatore = document.getElementById("cda_segnalatore");
            if (segnalatore && segnalatore.value != '' && cliente && cliente.value != '' && prodotto && prodotto.value != '') {
                document.getElementById("errMsg").innerHTML = "";
                document.getElementById("errMsg").style.display = 'none';
                ret = true;
            }
            else {
                document.getElementById("errMsg").innerHTML = "Compilare tutti i campi obbligatori.";
                $("#errMsg").effect("highlight");
                ret = false;
            }
            break;
        case 1:
            // ret = confirm("Vuoi proseguire?");
			ret = true; // rimuovere se si decommenta la linea precedente
            break;
        case 2:
            ret = true;
            break;
        default:
            ret = true;
            break;
    }
    return ret;
}
