# frozen_string_literal: true

# helper methods for RecordsController
module RecordsHelper
  def set_page_title
    prefix = if @collection && !has_search_parameters?
               "#{@collection.display_title} Collection Items"
             elsif @institution && !has_search_parameters?
               "#{institution_name} Items"
             elsif @collection && has_search_parameters?
               "#{render_search_to_page_title(params)} - #{@collection.display_title} Collection Items"
             elsif @institution && has_search_parameters?
               "#{render_search_to_page_title(params)} - #{institution_name} Items"
             end
    @page_title = "#{prefix} - #{application_name}"
  end
end