# frozen_string_literal: true
# overrides for default blacklight maps helpers
Rails.application.config.to_prepare do
  Blacklight::BlacklightMapsHelperBehavior.module_eval do
    # create a link to a bbox spatial search
    def link_to_bbox_search bbox_coordinates
      coords_for_search = bbox_coordinates.map { |v| v.to_s }
      link_to(t('blacklight.maps.interactions.bbox_search'),
              search_records_path(spatial_search_type: "bbox",
                                  coordinates: "[#{coords_for_search[1]},#{coords_for_search[0]} TO #{coords_for_search[3]},#{coords_for_search[2]}]",
                                  view: default_document_index_view_type))
    end

    # create a link to a location name facet value
    def link_to_placename_field field_value, field, displayvalue = nil
      if params[:f] && params[:f][field] && params[:f][field].include?(field_value)
        new_params = params
      else
        new_params = search_state.add_facet_params(field, field_value)
      end
      new_params[:view] = default_document_index_view_type
      link_to(displayvalue.presence || field_value,
              search_location_path(new_params.except(:id, :spatial_search_type, :coordinates)))
    end

    def search_location_path(params = nil)
      if controller.class.name.downcase.include? 'collections'
        search_collections_path(params)
      else
        search_records_path(params)
      end
    end

  end
end
