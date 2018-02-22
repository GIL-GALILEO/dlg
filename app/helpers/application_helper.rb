# frozen_string_literal: true

# Application-wide helpers
module ApplicationHelper
  def feature_image_link(v)
    "#{Rails.application.secrets.cache_server}#{v}"
  end
end
