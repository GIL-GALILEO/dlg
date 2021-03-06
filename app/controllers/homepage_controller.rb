# frozen_string_literal: true

# Serve up the homepage!
class HomepageController < CatalogController
  layout 'homepage'
  def index
    set_features
  end

  # return link to faceted main results page
  def search_action_url(options = {})
    search_records_path(options.except(:controller, :action))
  end

  private

  def set_features
    @carousel_features = Rails.cache.fetch(
      'carousel_features',
      expires_in: 5.minutes
    ) do
      MetaApiV2.new.features type: 'carousel', count: 5
    end
    @tabs_features = sorted_tabs

  end

  def sorted_tabs
    sorted = { secondary: [] }
    tabs_features = Rails.cache.fetch(
      'tabs_features',
      expires_in: 5.minutes
    ) do
      MetaApiV2.new.features(type: 'tab', count: 4)
    end
    tabs_features.each do |f|
      if f.primary
        sorted[:primary] = f
      else
        sorted[:secondary] << f
      end
    end
    sorted[:secondary].shuffle!
    return [] unless sorted[:primary]
    OpenStruct.new sorted
  rescue StandardError
    []
  end
end