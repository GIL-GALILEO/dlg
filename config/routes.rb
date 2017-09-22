Rails.application.routes.draw do

  mount Blacklight::Engine => '/'
  root to: 'records#index'

  concern :searchable, Blacklight::Routes::Searchable.new
  concern :exportable, Blacklight::Routes::Exportable.new

  resource :records, only: [:index] do
    concerns :searchable
  end

  resource :collections, only: [:index] do
    concerns :searchable
  end

  resources :items, only: [:show], as: 'collection_home', path: '/collection' do
    concerns :searchable
  end

  resources :solr_document, only: [:show], path: '/record', controller: 'records' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
end
