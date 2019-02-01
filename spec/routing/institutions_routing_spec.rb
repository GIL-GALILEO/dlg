# frozen_string_literal: true

require 'rails_helper'

describe InstitutionsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/institutions').to route_to 'institutions#index'
    end
    it 'routes to #show' do
      expect(get: '/institutions/abcd').to route_to 'institutions#show', id: 'abcd'
    end
  end
end