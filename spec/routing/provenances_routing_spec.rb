# frozen_string_literal: true

require 'rails_helper'

describe ProvenancesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/institutions').to route_to 'provenances#index'
    end
  end
end