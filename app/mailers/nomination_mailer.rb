# frozen_string_literal: true

# abstract class for system emails
class NominationMailer < ApplicationMailer
  RECIPIENTS = Rails.application.secrets.nomination_recipients
  def nomination_submission(data)
    data[:submitted_at] = Time.now
    @nomination = OpenStruct.new(data)
    mail(
      to: RECIPIENTS,
      subject: 'DLG Nomination Form Submission',
      template_path: 'mailers'
    )
  end
end
