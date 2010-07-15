function dock(){
    // set up the options to be used for jqDock...
    var dockOptions = {
        align: 'right' // vertical menu, with expansion LEFT from a fixed RIGHT edge
        ,
        distance: 24,
        labels: true // add labels (defaults to 'tl')
        ,
        fadeIn: 2000,
        size: 28
    };
    // ...and apply...
    $('#menu').jqDock(dockOptions);
}

$(document).ready(function(){
    dock();
});
