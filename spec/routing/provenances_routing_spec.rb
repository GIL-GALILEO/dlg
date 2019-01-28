# frozen_string_literal: true

require 'rails_helper'

describe InstitutionsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/institutions').to route_to 'institutions#index'
    end
  end
end