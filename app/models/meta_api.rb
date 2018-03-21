# frozen_string_literal: true

# Class to wrap Meta API
class MetaApi
  URI = 'https://dlgadmin.galileo.usg.edu'
  def self.carousel_items(count = 5)
    response = call "#{URI}/api/carousel_features?count=#{count}"
    return nil unless response
    response['records']
  end

  def self.tabs_items(count = 5)
    response = call "#{URI}/api/tab_features?count=#{count}"
    parse_tabs response
  end

  def self.record_info(id)
    response = call "#{URI}/api/info?record_id=#{id}"
    parse_record response
  end

  def self.parse_tabs(response)
    return nil unless response
    pr = response.parsed_response
    OpenStruct.new(tabs_types_data(pr['records']))
  rescue StandardError
    nil
  end

  def self.tabs_types_data(pr)
    ret = {}
    pr.each do |f|
      next unless f['primary']
      ret[:primary] = f
      pr.delete(f)
      break
    end
    ret[:secondary] = pr
    ret
  end

  def self.parse_record(response)
    return nil unless response
    OpenStruct.new(response.parsed_response)
  rescue StandardError
    nil
  end

  def self.call(url)
    response = HTTParty.get(
      url, headers: { 'X-User-Token': Rails.application.secrets.meta_api_key }
    )
    return nil unless response.code == 200
    response
  rescue StandardError
    nil
  end
end