function setupMenu(el){
    phone_attr = el.attributes['phone'];
	if (phone_attr == undefined) {
        $('#utentiCM').disableContextMenuItems('#phone');
    }
    else {
        $('#utentiCM').enableContextMenuItems('#phone');
        /*alert("Telefono: " + $('#phone').html());*/
		$('#phone_cm').text(phone_attr.value);
    }
    if (el.attributes['skype'] == undefined) {
        $('#utentiCM').disableContextMenuItems('#skype_chat');
        $('#utentiCM').disableContextMenuItems('#skype_call');
    }
    else {
        $('#utentiCM').enableContextMenuItems('#skype_chat');
        $('#utentiCM').enableContextMenuItems('#skype_call');
    }
    if (el.attributes['mail'] == undefined) {
        $('#utentiCM').disableContextMenuItems('#email');
    }
    else {
        $('#utentiCM').enableContextMenuItems('#email');
        $('#email_cm').text(el.attributes['mail'].value);
    }
}

$(document).ready(function(){

    // Mostra il menu al clic col destro su un utente
    $(".utente").contextMenu({
        menu: 'utentiCM'
    }, function(el){
        if (el.attributes['phone'] == undefined) {
            $('#utentiCM').disableContextMenuItems('#phone');
        }
        else {
            $('#utentiCM').enableContextMenuItems('#phone');
            $('#phone').html(el.attributes['phone'].value);
        }
        if (el.attributes['skype'] == undefined) {
            $('#utentiCM').disableContextMenuItems('#skype_chat');
            $('#utentiCM').disableContextMenuItems('#skype_call');
        }
        else {
            $('#utentiCM').enableContextMenuItems('#skype_chat');
            $('#utentiCM').enableContextMenuItems('#skype_call');
        }
        if (el.attributes['mail'] == undefined) {
            $('#utentiCM').disableContextMenuItems('#email');
        }
        else {
            $('#utentiCM').enableContextMenuItems('#email');
            $('#email').html(el.attributes['mail'].value);
        }
    }, function(action, el, pos){
        if (action == 'phone') {
            alert(el.attr('phone'));
        }
        else 
            if (action == 'email') {
                parent.location.href = 'mailto:' + el.attr('mail');
            }
            else 
                if (action == 'skype_chat') {
                    parent.location.href = 'skype:' + el.attr('skype') + '?chat';
                }
                else 
                    if (action == 'skype_call') {
                        parent.location.href = 'skype:' + el.attr('skype') + '?call';
                    }
    });
    
    // Disable menus
    $("#disableMenus").click(function(){
        $('#myDiv, #myList UL LI').disableContextMenu();
        $(this).attr('disabled', true);
        $("#enableMenus").attr('disabled', false);
    });
    
    // Enable menus
    $("#enableMenus").click(function(){
        $('#myDiv, #myList UL LI').enableContextMenu();
        $(this).attr('disabled', true);
        $("#disableMenus").attr('disabled', false);
    });
    
    // Disable cut/copy
    $("#disableItems").click(function(){
        $('#myMenu').disableContextMenuItems('#cut,#copy');
        $(this).attr('disabled', true);
        $("#enableItems").attr('disabled', false);
    });
    
    // Enable cut/copy
    $("#enableItems").click(function(){
        $('#myMenu').enableContextMenuItems('#cut,#copy');
        $(this).attr('disabled', true);
        $("#disableItems").attr('disabled', false);
    });
    
});
