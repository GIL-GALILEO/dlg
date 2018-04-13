# frozen_string_literal: true

# Contextual help helpers
module HelpHelper
  def help_link(section)
    label = I18n.t section, scope: :help
    link_to(
      "<i class='glyphicon glyphicon-question-sign'></i> #{label}".html_safe,
      { controller: :help, action: section },
      class: 'btn btn-default', data: { ajax_modal: 'trigger' }
    )
  end

  def refine_help
    if controller.class.name =~ /Collection/
      'refine_collections'
    else
      'refine_items'
    end
  end
end
