# frozen_string_literal: true

# helper methods for Blacklight catalog pages
module CatalogHelper

  include Blacklight::CatalogHelperBehavior

  COORDINATES_REGEXP = /(-?\d+\.\d+), (-?\d+\.\d+)/
  INDEX_TRUNCATION_VALUE = 2500
  NO_THUMB_ICON = 'no_thumb.gif'

  # show friendly values for boolean fields
  def boolean_facet_labels(value)
    value == 'true' ? 'Yes' : 'No'
  end

  # handle linking in catalog results
  def linkify(options = {})
    url = options[:value].first
    link_to url, url
  end

  # truncate fields when displaying search results
  def truncate_index(options = {})
    truncate(
      options[:value].join(I18n.t('support.array.two_words_connector')),
      length: INDEX_TRUNCATION_VALUE,
      omission: I18n.t('search.index.truncated_field')
    )
  end

  # show rightsstatements.org or cc label corresponding to rights uri value
  def rights_icon_label(uri)
    I18n.t(:rights).each do |r|
      return r[1][:label] if r[1][:uri] == uri
    end
    uri # return uri if no match found
  end

  # show thumbnail for item, or placeholder if none found
  def record_thumbnail(document, _options)
    url = case document['sunspot_id_ss'].split(' ')[0]
          when 'Item'
            if document.key?('slug_ss') &&
               document.key?('collection_slug_ss') &&
               document.key?('repository_slug_ss')
              "http://dlg.galileo.usg.edu/#{document['repository_slug_ss']}/#{document['collection_slug_ss']}/do-th:#{document['slug_ss']}"
            else
              NO_THUMB_ICON
            end
          when 'Collection'
            document['thumbnail_ss']
          else
            NO_THUMB_ICON
          end
    image_tag(url, class: 'thumbnail')
  end

  def spatial_cleaner(value)
    if value =~ COORDINATES_REGEXP
      value.sub(COORDINATES_REGEXP, '')[0...-2]
    else
      # value contains no coordinates
      value
    end
  end

  def link_to_collection_page(options)
    collection_title = options[:document][:collection_name_sms].first
    collection_slug = options[:document][:slug_ss]
    link_to collection_title, collection_home_path(collection_slug)
  end

end