# frozen_string_literal: true

# helper methods for Blacklight catalog pages
module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  COORDINATES_REGEXP = /(-?\d+\.\d+), (-?\d+\.\d+)/
  INDEX_TRUNCATION_VALUE = 2500

  def search_bar_placeholder
    if @collection
      I18n.t 'search.bar.placeholder.collection', collection: @collection.display_title
    elsif controller.class.name.downcase =~ /collections/
      I18n.t 'search.bar.placeholder.collections'
    else
      I18n.t('search.bar.placeholder.default')
    end
  end

  def strip_html(options = {})
    strip_tags(options[:value].first)
  end

  # truncate fields when displaying search results
  def truncate_index(options = {})
    truncate(
      options[:value].join(I18n.t('support.array.two_words_connector')),
      length: INDEX_TRUNCATION_VALUE,
      omission: I18n.t('search.index.truncated_field')
    )
  end

  def spatial_cleaner(value)
    if value =~ COORDINATES_REGEXP
      value.sub(COORDINATES_REGEXP, '')[0...-2]
    else
      value
    end
  end

  def type_cleaner(value)
    value.underscore.split('_').collect(&:capitalize).join(' ')
  end

  # Render human-readable label for RS.org value, if available and URI otherwise
  def rights_icon_label(uri)
    I18n.t([:rights])[0].each do |r|
      return r[1][:label] if r[1][:uri] == uri
    end
    uri
  end
end