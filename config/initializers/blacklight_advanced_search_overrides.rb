# frozen_string_literal: true

# overrides for default blacklight maps helpers
Rails.application.config.to_prepare do
  BlacklightAdvancedSearch::RenderConstraintsOverride.module_eval do
    def render_constraints_query(my_params = params)
      if advanced_query.nil? || advanced_query.keyword_queries.empty?
        return super(my_params)
      else
        content = []
        advanced_query.keyword_queries.each_pair do |field, query|
          label = blacklight_config.search_fields[field][:label]
          content << render_constraint_element(
            label, query,
            remove: search_action_path(remove_advanced_keyword_query(field, my_params).except(:controller, :action))
          )
        end
        if advanced_query.keyword_op == 'OR' &&
            advanced_query.keyword_queries.length > 1
          content.unshift content_tag(:span, 'Any of:', class: 'operator')
          content_tag :span, class: 'inclusive_or appliedFilter well' do
            safe_join(content.flatten, "\n")
          end
        else
          safe_join(content.flatten, "\n")
        end
      end
    end
  end
end
