# frozen_string_literal: true

# controller for SavedSearch actions
class SavedSearchesController < ApplicationController
  include Blacklight::SavedSearches
  helper BlacklightMaps::RenderConstraintsOverride
  helper BlacklightAdvancedSearch::RenderConstraintsOverride
end
