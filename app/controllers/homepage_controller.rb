# frozen_string_literal: true

# Serve up the homepage!
class HomepageController < CatalogController
  layout 'homepage'
  def index
    @carousel_features = MetaApi.carousel_items 5
    @tabs_features = MetaApi.tabs_items 4
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end
end