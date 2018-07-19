# frozen_string_literal: true

# controller for search history actions
class SearchHistoryController < ApplicationController
  include Blacklight::Configurable
  helper BlacklightMaps::RenderConstraintsOverride
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
  helper BlacklightRangeLimit::ViewHelperOverride
  helper RangeLimitHelper

  # formerly included module code pasted here to easily override
  # the copying of config from CatalogController
  copy_blacklight_config_from(RecordsController)

  def index
    @searches = searches_from_history
  end

  # TODO: we may want to remove unsaved (those without user_id) items from
  # the database when removed from history
  def clear
    if session[:history].clear
      flash[:notice] = I18n.t('blacklight.search_history.clear.success')
    else
      flash[:error] = I18n.t('blacklight.search_history.clear.failure')
    end
    if respond_to? :redirect_back
      redirect_back fallback_location: blacklight.search_history_path
    else
      # Deprecated in Rails 5.0
      redirect_to :back
    end
  end

  def search_catalog_url(options = {})
    search_records_url(options)
  end
end
