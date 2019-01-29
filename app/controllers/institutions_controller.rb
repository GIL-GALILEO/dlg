# frozen_string_literal: true

# handle actions for Institution browse page
class InstitutionsController < HomepageController
  # returns a paginated set of holding institution objects from the MetaApiV2
  def index
    # query supports type, letter, page and per_page. default per page is 20
    @institutions = MetaApiV2.new.holding_institutions(
      per_page: institution_params[:per_page],
      page: institution_params[:page],
      letter: institution_params[:letter][0], # only first letter, please
      type: institution_params[:type]
    )
  end

  private

  def institution_params
    params.permit(:page, :per_page, :letter, :type)
  end
end