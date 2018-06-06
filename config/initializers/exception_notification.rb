# frozen_string_literal: true

require 'exception_notification/rails'

ExceptionNotification.configure do |config|
  config.ignore_if do |_, _|
    Rails.env.test? || Rails.env.development?
  end
  config.ignored_exceptions += %w[Blacklight::Exceptions::RecordNotFound]
  config.error_grouping = true
  config.add_notifier :slack,
                      webhook_url: Rails.application.secrets.slack_webhook_url,
                      channel: '#app-exceptions',
                      username: 'dlg-public',
                      additional_parameters: {
                        icon_emoji: ':boom:',
                        mrkdwn: true
                      }
end