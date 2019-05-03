# frozen_string_literal: true

# handle actions for Institution browse page
class InstitutionsController < RecordsController
  # returns a paginated set of holding institution objects from the MetaApiV2
  def index
    # query supports type, letter and page
    @institutions = MetaApiV2.new.holding_institutions(
      page: institution_params[:page],
      letter: letter, # only first letter, please
      type: institution_type
    )
  end

  def show
    @institution = MetaApiV2.new.holding_institution params[:id]
    redirect_to '/404' unless @institution
    params[:institution_slug] = @institution.slug
  end

  private

  def institution_params
    params.permit(:page, :letter, :type)
  end

  def letter
    institution_params.key?(:letter) ? institution_params[:letter][0] : nil
  end

  def institution_type
    if institution_params[:type] == 'All'
      nil
    else
      institution_params[:type]
    end
  end
end