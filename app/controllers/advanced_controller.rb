# override BL Adv Search plugin to reference RecordsController config
class AdvancedController < BlacklightAdvancedSearch::AdvancedController
  copy_blacklight_config_from RecordsController
  # override from Blacklight::UrlHelperBehavior
  def search_action_url(options = {})
    search_records_url(options.except(:controller, :action))
  end
end