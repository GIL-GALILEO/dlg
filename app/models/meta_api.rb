# frozen_string_literal: true

require 'ostruct'

# Class to wrap Meta API
class MetaApi
  URI = 'https://dlgadmin.galileo.usg.edu'
  def self.carousel_items(count = 5)
    call "#{URI}/api/carousel_features?count=#{count}"
  end

  def self.tabs_items(count = 5)
    call "#{URI}/api/tab_features?count=#{count}"
  end

  def self.record_info(id)
    call "#{URI}/api/info?record_id=#{id}"
  end

  def self.call(url)
    r = HTTParty.get(
      url, headers: { 'X-User-Token': Rails.application.secrets.meta_api_key }
    )
    if r.response.code == '200'
      obj = r.parsed_response
      if obj.key? 'records'
        obj['records'] = obj['records']
        obj
      else
        OpenStruct.new(obj)
      end
    else
      {}
    end
  rescue JSON::JSONError
    # TODO: log error
    {}
  end
end