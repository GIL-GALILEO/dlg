// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require chosen-jquery
//= require leaflet
//= require rails-ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require 'blacklight_advanced_search'
//= require blacklight_range_limit
//= require blacklight/blacklight
//= require_tree .

Blacklight.onLoad(function() {

    // Remove thumbnail img if thumbnail fails to load
    $('img.thumbnail').on('error', function(){
        this.remove();
    });

    // handling for secondary submit button to advanced search form
    var $auxAdvSubmit = $('button.auxiliary-advanced-search-submit');
    $auxAdvSubmit.click(function() {
        $('form.advanced').submit()
    });
    $auxAdvSubmit.removeClass('hide');

    // chosenify advanced search facet selects
    $('select.advanced-search-facet-select').chosen({
        search_contains: true,
        width: '100%'
    });

    // chosenify nomination form selects
    $('select.nomination-select').chosen();

});