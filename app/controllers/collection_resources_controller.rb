# frozen_string_literal: true

# Collection Resource controller
class CollectionResourcesController < HomepageController
  def show
    collection_data = MetaApiV2.collection(params[:collection_record_id])
    # TODO: this is way too crufty...
    @page_content = collection_data['collection_resource'][params['collection_resource_slug']]
  end
end
