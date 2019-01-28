# frozen_string_literal: true

# handle actions for Institution browse page
class InstitutionsController < ApplicationController
  # returns a paginated set of holding institution objects from the MetaApiV2
  def index
    # query supports type, letter, page and per_page. default per page is 20
    @institutions = MetaApiV2.new.holding_institutions(
      per_page: params[:per_page], page: params[:page], letter: params[:letter],
      type: params[:type]
    )
  end
end