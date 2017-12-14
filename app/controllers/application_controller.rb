# frozen_string_literal: true

# Main App controller
class ApplicationController < ActionController::Base
  helper Openseadragon::OpenseadragonHelper
  include Blacklight::Controller
  layout 'blacklight'
  protect_from_forgery with: :exception
end
