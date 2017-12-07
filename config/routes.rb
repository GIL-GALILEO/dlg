# frozen_string_literal: true

Rails.application.routes.draw do
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  resource :records, only: [:index] do
    get 'map', to: 'map', as: 'map'
    concerns :searchable
    concerns :range_searchable

  end
  resource :collections, only: [:index] do
    get 'map', to: 'map', as: 'map'
    concerns :searchable
    concerns :range_searchable

  end

  get '/collection/:collection_record_id', to: 'records#index', as: 'collection_home'
  get '/counties', to: 'counties#index', as: 'counties'
  get '/institutions', to: 'provenances#index', as: 'institutions'

  resources :solr_document, only: [:show], path: '/record', controller: 'records' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  get 'advanced', to: 'advanced#index'
  get 'advanced/range_limit', to: 'advanced#range_limit'

  root to: 'records#index'
end
