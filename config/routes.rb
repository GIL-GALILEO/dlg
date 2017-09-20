Rails.application.routes.draw do

  mount Blacklight::Engine => '/'
  root to: 'both#index'

  concern :searchable, Blacklight::Routes::Searchable.new

  # TODO: work to remove this
  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  resource :both, only: [:index], as: 'both', path: '/records', controller: 'both' do
    concerns :searchable
  end

  resources :item, only: [:show], as: 'collection_home', path: '/collection', controller: 'item' do
    concerns :searchable
  end

  resource :item, only: [:index], as: 'item', path: '/items', controller: 'item' do
    concerns :searchable
  end

  resource :collection, only: [:index], as: 'collection', path: '/collections', controller: 'collection' do
    concerns :searchable
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
end
