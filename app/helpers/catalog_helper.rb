# frozen_string_literal: true

# helper methods for Blacklight catalog pages
module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  COORDINATES_REGEXP = /(-?\d+\.\d+), (-?\d+\.\d+)/
  INDEX_TRUNCATION_VALUE = 2500

  def identifier_for(document)
    document['record_id_ss']
  end

  def do_url?(document)
    document.key?('edm_is_shown_by_display') &&
      document['edm_is_shown_by_display'].first =~ URI.regexp
  end

  def md_url?(document)
    document.key?('edm_is_shown_at_display') &&
      document['edm_is_shown_at_display'].first =~ URI.regexp
  end

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
    no_coordinates = if value =~ COORDINATES_REGEXP
                       value.sub(COORDINATES_REGEXP, '')[0...-2]
                     else
                       value
                     end
    clean_value = no_coordinates.gsub('United States, ', '').gsub('United States', '')
    clean_value.empty? ? no_coordinates : clean_value
  end

  # Render human-readable label for RS.org value, if available and URI otherwise
  def rights_icon_label(uri)
    I18n.t([:rights])[0].each do |r|
      return r[1][:label] if r[1][:uri] == uri
    end
    uri
  end

  def render_array_field(array_of_text, num, id)
    str = ''
    array_of_text.each_with_index do |v, i|
      if num == i
        str += link_to(I18n.t('collection.see_more'), solr_document_path(id), data: { turbolinks: false })
        return str.html_safe
      end
      str += "#{v}<br />"
    end
    str.html_safe
  end
end