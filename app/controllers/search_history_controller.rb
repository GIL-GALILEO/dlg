# frozen_string_literal: true

# controller for search history actions
class SearchHistoryController < ApplicationController
  include Blacklight::SearchHistory
  helper BlacklightMaps::RenderConstraintsOverride
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
