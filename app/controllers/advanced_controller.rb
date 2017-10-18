# override BL Adv Search plugin to reference RecordsController config
class AdvancedController < BlacklightAdvancedSearch::AdvancedController
  copy_blacklight_config_from RecordsController
end