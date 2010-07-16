$().ready(function(){
    $('.wiz-container').smartWizard({
        selectedStep: $('#lastWiz').attr('value'),
        validatorFunc: validateTabs
    });
	
	if ($('#lastWiz').attr('value') == 4) {
		$('wiz-nav').hide();
	}
});

function validateTabs(tabIdx){
    ret = true;
    switch (tabIdx) {
        case 0:
            if (document.getElementById("cda_segnalatore").value != '' && document.getElementById("cda_cliente").value != '' &&
            document.getElementsByClassName("segnalazione_cod_prodotto").value != '') {
                document.getElementById("errMsg").innerHTML = "";
                document.getElementById("errMsg").style.display = 'none';
                ret = true;
            }
            else {
                document.getElementById("errMsg").innerHTML = "Compilare tutti i campi obbligatori.";
                //document.getElementById("errMsg").style.display='block';
                //alert($("#errMsg").html());
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
