# frozen_string_literal: true

# override BL Adv Search plugin to reference RecordsController config
class AdvancedController < BlacklightAdvancedSearch::AdvancedController
  copy_blacklight_config_from RecordsController
  def search_action_url(options = {})
    search_records_url(options.except(:controller, :action))
  end
end