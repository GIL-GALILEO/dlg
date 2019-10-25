//= require openseadragon/openseadragon
//= require openseadragon/rails

$(document).on('turbolinks:load', function() {
    var viewer = $('#Openseadragon1').data('osdViewer');
    viewer.addHandler('page', function (data) {
        var page = data.page;
        document.getElementById('osd-page-number').innerHTML = ( page + 1 );
        // TODO: update URL and add page param
        // var newUrl = url.split("#")[0] + page;
        // history.replaceState(null, null, newUrl);
    });
});