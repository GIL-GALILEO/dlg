# frozen_string_literal: true

Rails.application.routes.draw do
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'


  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  resource :records, only: [:index] { concerns :searchable }
  resource :collections, only: [:index] { concerns :searchable }

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

  root to: 'records#index'
end
