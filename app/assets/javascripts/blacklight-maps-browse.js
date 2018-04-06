;(function( $ ) {

  $.fn.blacklight_leaflet_map = function(geojson_docs, arg_opts) {
    var map, sidebar, markers, geoJsonLayer, currentLayer, leader_html;

    // Configure default options and those passed via the constructor options
    var options = $.extend({
      tileurl : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
      mapattribution : 'Map data &copy; <a href="https://openstreetmap.org" target="_blank">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
      initialZoom: 2,
      singlemarkermode: true,
      searchcontrol: false,
      catalogpath: 'records',
      searchctrlcue: 'Search for all items within the current map window',
      placenamefield: 'placename_field',
      nodata: 'Sorry, there is no data for this location.',
      clustercount:'locations',
      searchresultsview: 'gallery'
    }, arg_opts );

    // Extend options from data-attributes
    $.extend(options, this.data());

    var $leaderHtmlDiv = $('#map-leader');
    var $indexMapContainer = $('#index-map-container');

    // elements to hide when using map view on search results
    var $pagination = $('.pagination');
    var $page_links = $('.page_links');
    var $sort = $('#sort-dropdown');
    var $per_page = $('#per_page-dropdown');

    // Update page links with number of mapped items, disable sort, per_page, pagination
    // Customized for DLG use to hide view widgets and change language for item/location counts
    if ($indexMapContainer.length) { // catalog#index and #map view
      $pagination.hide();
      $page_links.hide();
      $sort.hide();
      $per_page.hide();
      var result_count = $('#mapped-record-count').text();
      leader_html = '<span class="badge badge-default">' + result_count + '</span> total items found.';
    } else { // catalog#show view
      leader_html = '<span class="badge badge-default">' + geojson_docs.features.length + '</span> locations associated with this record';
    }

    $leaderHtmlDiv.html(leader_html);

    // determine whether to use item location or result count in cluster icon display
    if (options.clustercount == 'hits') {
      var clusterIconFunction = function (cluster) {
        var markers = cluster.getAllChildMarkers();
        var childCount = 0;
        for (var i = 0; i < markers.length; i++) {
          childCount += markers[i].feature.properties.hits;
        }
        var c = ' marker-cluster-';
        if (childCount < 10) {
          c += 'small';
        } else if (childCount < 100) {
          c += 'medium';
        } else {
          c += 'large';
        }
        return new L.divIcon({ html: '<div><span>' + childCount + '</span></div>', className: 'marker-cluster' + c, iconSize: new L.Point(40, 40) });
      };
    } else {
      var clusterIconFunction = this._defaultIconCreateFunction;
    }

    // Display the map
    this.each(function() {
      options.id = this.id;

      // Setup Leaflet map
      map = L.map(this.id, {
        center: [0, 0],
        zoom: options.initialZoom,
        scrollWheelZoom: false
      });

      // intuitive handling of mousewheel zooming
      map.on('focus', function() { map.scrollWheelZoom.enable(); });
      map.on('blur', function() { map.scrollWheelZoom.disable(); });

      L.tileLayer(options.tileurl, {
        attribution: options.mapattribution,
        maxZoom: options.maxzoom
      }).addTo(map);

      // Create a marker cluster object and set options
      markers = new L.MarkerClusterGroup({
        singleMarkerMode: options.singlemarkermode,
        iconCreateFunction: clusterIconFunction
      });

      geoJsonLayer = L.geoJson(geojson_docs, {
        onEachFeature: function(feature, layer){
          if (feature.properties.popup) {
              layer.bindPopup(feature.properties.popup);
          } else {
              layer.bindPopup(options.nodata);
          }
        }
      });

      // Add GeoJSON layer to marker cluster object
      markers.addLayer(geoJsonLayer);

      // Add markers to map
      map.addLayer(markers);

      // Fit bounds of map
      setMapBounds(map);

      // create overlay for search control hover
      var searchHoverLayer = L.rectangle([[0,0], [0,0]], {
        color: "#0E8893",
        weight: 5,
        opacity: 0.5,
        fill: true,
        fillColor: "#0E8893",
        fillOpacity: 0.2
      });

      // create search control if full map view (no facets displayed TODO: improve)
      if(!$('#facets').length) {
          var searchControl = L.Control.extend({

              options: { position: 'topright' },

              onAdd: function (map) {
                  var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
                  this.link = L.DomUtil.create('a', 'search-control', container);
                  // this.link.title = options.searchctrlcue;
                  this.link.innerHTML = 'Show Items in This Area';
                  // this.icon = L.DomUtil.create('i', 'glyphicon glyphicon-search', this.link);

                  L.DomEvent.addListener(this.link, 'click', _search);

                  L.DomEvent.addListener(this.link, 'mouseover', function () {
                      searchHoverLayer.setBounds(map.getBounds());
                      map.addLayer(searchHoverLayer);
                  });

                  L.DomEvent.addListener(this.link, 'mouseout', function () {
                      map.removeLayer(searchHoverLayer);
                  });

                  return container;
              }

          });

          // add search control to map
          if (options.searchcontrol === true) {
              map.addControl(new searchControl());
          }
      }


    });

    /**
    * Sets the view of the map, based off of the map bounds
    */
    function setMapBounds() {
      map.fitBounds(mapBounds(), {
        padding: [10, 10],
        maxZoom: options.maxzoom
      });
    }

    /**
    * Returns the bounds of the map based off of initialview being set or gets
    * the bounds of the markers object
    */
    function mapBounds() {
      if (options.initialview) {
        return options.initialview;
      } else {
        return markerBounds();
      }
    }

    /**
    * Returns the bounds of markers, if there are not any return
    */
    function markerBounds() {
      if (hasAnyFeatures()) {
        return markers.getBounds();
      } else {
        return [[90, 180], [-90, -180]];
      }
    }

    /**
    * Checks to see if there are any features in the markers MarkerClusterGroup
    */
    function hasAnyFeatures() {
      var has_features = false;
      markers.eachLayer(function (layer) {
        if (!$.isEmptyObject(layer)) {
          has_features = true;
        }
      });
      return has_features;
    }

    // remove stale params, add new params, and run a new search
    function _search() {
      var params = filterParams(['view', 'spatial_search_type', 'coordinates', 'f%5B' + options.placenamefield + '%5D%5B%5D']),
          bounds = map.getBounds().toBBoxString().split(',').map(function(coord) {
            if (parseFloat(coord) > 180) {
              coord = '180'
            } else if (parseFloat(coord) < -180) {
              coord = '-180'
            }
            return Math.round(parseFloat(coord) * 1000000) / 1000000;
          }),
          coordinate_params = '[' + bounds[1] + ',' + bounds[0] + ' TO ' + bounds[3] + ',' + bounds[2] + ']';
      params.push('coordinates=' + encodeURIComponent(coordinate_params), 'spatial_search_type=bbox', 'view=' + options.searchresultsview);
      $(location).attr('href', options.catalogpath + '?' + params.join('&'));
    }

    // remove unwanted params
    function filterParams(filterList) {
      var querystring = window.location.search.substr(1),
          params = [];
      if (querystring !== "") {
        params = $.map(querystring.split('&'), function(value) {
          if ($.inArray(value.split('=')[0], filterList) > -1) {
            return null;
          } else {
            return value;
          }
        });
      }
      return params;
    }

  };

}( jQuery ));
