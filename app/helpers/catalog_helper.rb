module CatalogHelper

  include Blacklight::CatalogHelperBehavior

  INDEX_TRUNCATION_VALUE = 2500
  NO_THUMB_ICON = 'no_thumb.gif' # todo replace with no thumb placeholder

  def boolean_facet_labels(value)
    value == 'true' ? 'Yes' : 'No'
  end

  # handle linking in catalog results
  def linkify(options = {})
    url = options[:value].first
    link_to url, url
  end

  # truncate when displaying search results
  def truncate_index(options = {})
    truncate(
        options[:value].join(I18n.t('support.array.two_words_connector')),
        length: INDEX_TRUNCATION_VALUE,
        omission: I18n.t('search.index.truncated_field')
    )
  end

  def rights_icon_label(uri)
    I18n.t(:rights).each do |r|
      return r[1][:label] if r[1][:uri] == uri
    end
    uri # return uri if no match found
  end

  def record_thumbnail(document, options)
    url = case document['sunspot_id_ss'].split(' ')[0]
            when 'Item'
              if document.has_key?('slug_ss') &&
                  document.has_key?('collection_slug_ss') &&
                  document.has_key?('repository_slug_ss')
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

end