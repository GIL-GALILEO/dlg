# frozen_string_literal: true

# Class to wrap Meta API V2
class MetaApiV2
  include HTTParty
  base_uri 'https://dlgadmin.galileo.usg.edu/api/v2'

  def initialize
    @options = {
      headers: { 'X-User-Token': Rails.application.secrets.meta_api_key }
    }
  end

  def holding_institutions(options = {})
    r = self.class.get '/holding_institutions', @options.merge(options)
    r.parsed_response
  end

  def holding_institution(id)
    r = self.class.get "/holding_institutions/#{id}", @options
    r.parsed_response
  end
end