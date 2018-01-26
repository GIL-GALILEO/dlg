# frozen_string_literal: true

# Serve up the homepage!
class HomepageController < RecordsController
  layout 'blacklight'
  def index
    @carousel_features = MetaApi.carousel_items 5
    @tabs_features = MetaApi.tabs_items 5
    a
  end
end