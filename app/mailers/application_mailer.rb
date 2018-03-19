# frozen_string_literal: true

# abstract class for system emails
class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@uga.edu'
  layout 'mailer'
end