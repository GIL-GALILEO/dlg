# frozen_string_literal: true

Rails.application.routes.draw do
  mount Blacklight::Engine => '/'
  mount BlacklightAdvancedSearch::Engine => '/'

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new
  concern :range_searchable, BlacklightRangeLimit::Routes::RangeSearchable.new

  resource :records, only: [:index] do
    get 'map', to: 'map', as: 'map'
    concerns :searchable
    concerns :range_searchable
  end

  get '/collection/:collection_record_id',
      to: 'records#index', as: 'collection_home'

  resource :collections, only: [:index] do
    get 'map', to: 'map', as: 'map'
    concerns :searchable
    concerns :range_searchable
    member do
      get(
        '/:collection_record_id/:collection_resource_slug',
        to: 'collection_resources#show',
        as: 'resource_page'
      )
    end
  end

  resources :institutions, only: %i[index show]

  get '/search', to: 'advanced#index', as: 'search'
  get '/counties', to: 'counties#index', as: 'counties'

  resources :solr_document, only: [:show], path: '/record',
                            controller: 'records' do
    concerns :exportable
    get 'fulltext', to: 'records#fulltext'
  end

  resources :bookmarks do
    concerns :exportable
    collection do
      delete 'clear'
    end
  end

  namespace :teach do
    get 'using-materials'
  end

  namespace :participate do
    get 'contribute'
    get 'nominate'
    get 'partner-services'
    post 'nomination'
  end

  namespace :about do
    get 'mission'
    get 'policy'
    get 'partners-sponsors'
    get 'api'
  end

  namespace :help do
    get 'search'
    get 'refine-items'
    get 'refine-collections'
    get 'map'
  end

  root to: 'homepage#index'

  match '/404', to: 'errors#file_not_found', via: :all
  match '/422', to: 'errors#unprocessable', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
