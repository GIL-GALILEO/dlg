# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecordsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/records').to route_to 'records#index'
    end
  end
end