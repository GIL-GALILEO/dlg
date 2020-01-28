# frozen_string_literal: true

# Collection Resource controller
class CollectionResourcesController < HomepageController
  def show
    api = MetaApiV2.new
    @collection = api.collection(params[:collection_record_id])
    @resource = api.collection_resource(
      params[:collection_record_id],
      params[:collection_resource_slug]
    )
  end
end
