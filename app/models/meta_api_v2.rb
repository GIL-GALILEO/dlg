# frozen_string_literal: true

# Class to wrap Meta API V2
class MetaApiV2
  include HTTParty
  base_uri Rails.application.secrets.meta_api_url

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

  def collection_resource(collection_id, resource_slug)
    get "/collections/#{collection_id}/resource/#{resource_slug}"
  end

  private

  def get(url, options = params)
    data = self.class.get(url, options).parsed_response
    data.present? ? OpenStruct.new(data) : nil
  rescue StandardError => e
    # TODO: is this right? test this case
    OpenStruct.new
  end

  def get_many(url, options = params)
    response = self.class.get(url, options).parsed_response
    if response.present?
      response.map do |entity|
        OpenStruct.new entity
      end
    else
      nil
    end
  rescue StandardError => e
    []
  end

  def params(query = {})
    options = @options
    options[:query] = query.merge(DEFAULT_QUERY_PARAMS)
                           .reject { |_, v| v.blank? }
    options
  end
end