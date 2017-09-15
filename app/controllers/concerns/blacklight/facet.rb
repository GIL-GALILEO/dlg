# frozen_string_literal: true
module Blacklight
  # add helpers to support facet groups
  # see unmerged blacklight PR @
  # https://github.com/projectblacklight/blacklight/pull/1651
  module Facet
    def facet_field_names(group = nil)
      blacklight_config.facet_fields.select do |_,opts|
        group == opts[:group]
      end.values.map(&:field)
    end

    def facet_group_names
      blacklight_config.facet_fields.map { |_,opts| opts[:group] }.uniq
    end
  end
end