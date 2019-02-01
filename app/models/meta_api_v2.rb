# frozen_string_literal: true

# Class to wrap Meta API V2
class MetaApiV2
  include HTTParty
  base_uri 'https://dlgadmin.galileo.usg.edu/api/v2'

  DEFAULT_QUERY_PARAMS = { portal: 'georgia' }.freeze

  def initialize
    @options = {
      headers: { 'X-User-Token': Rails.application.secrets.meta_api_key }
    }
  end

  def features(query = {})
    get_many '/features', params(query)
  end

  def holding_institutions(query = {})
    get_many '/holding_institutions', params(query)
  end

  def holding_institution(id)
    get "/holding_institutions/#{id}"
  end

  def collections(query = {})
    get_many '/collections', params(query)
  end

  def collection(id)
    get "/collections/#{id}"
  end

  private

  def get(url, options = params)
    data = self.class.get(url, options).parsed_response
    data.present? ? OpenStruct.new(data) : nil
  rescue StandardError
    nil
  end

  def get_many(url, options = params)
    response = self.class.get(url, options)
    return [] unless response.code == 200
    response.parsed_response.map do |entity|
      OpenStruct.new entity
    end
  rescue StandardError
    []
  end

  def params(query = {})
    options = @options
    options[:query] = query.merge(DEFAULT_QUERY_PARAMS)
                           .reject { |_, v| v.blank? }
    options
  end
end