# frozen_string_literal: true

# Application-wide helpers
module ApplicationHelper
  def cache_server_image_link(v)
    "#{Rails.application.secrets.cache_server}#{v}"
  end

  def strip_html(options = {})
    strip_tags(options[:value].first)
  end
end
