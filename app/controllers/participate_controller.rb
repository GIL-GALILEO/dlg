# frozen_string_literal: true

# "Participate" menu item static page controller
class ParticipateController < HomepageController
  before_action :form_options, only: %i[nominate nomination]

  def contribute; end

  def nominate; end

  def nomination
    mail = NominationMailer.nomination_submission nominate_params
    sent = if mail.respond_to? :deliver_now
             mail.deliver_now
           else
             mail.deliver
           end
    respond_to do |format|
      format.html do
        if sent
          flash[:notice] = I18n.t('mail.nomination.status.sent')
        else
          flash[:error] = I18n.t('mail.nomination.status.failed')
        end
        redirect_to participate_nominate_path
      end
    end
  end

  def partner_services; end

  def promotional_materials; end

  private

  def form_options
    @form_options = {}
    @form_options[:types] = [
      ['Manuscript (handwritten documents, letters, etc.)', 'MSS'],
      ['Typescript (typewritten documents)', 'Typescript'],
      ['Book'], ['Maps/Broadsides/Posters'], ['Pamphlet'],
      ['Photographs'], ['Audio'], ['Video'], ['Other']
    ]
  end

  def nominate_params
    params.permit(
      :collection_name,
      :repository_name,
      :repository_contact,
      :collection_type_details,
      :collection_information,
      :md_gil,
      :md_finding_aid,
      :md_other,
      :collection_metadata_other,
      :publication_status,
      :publication_status_details,
      :transcription_information,
      :nomination_reason,
      :restrictions,
      :preservation_concerns,
      :skills,
      :homeplace,
      :name,
      :address,
      :phone,
      :email,
      collection_types: []
    )
  end
end
