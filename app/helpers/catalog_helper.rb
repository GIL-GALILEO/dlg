# frozen_string_literal: true

# helper methods for Blacklight catalog pages
module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  COORDINATES_REGEXP = /(-?\d+\.\d+), (-?\d+\.\d+)/
  INDEX_TRUNCATION_VALUE = 2500
  NO_THUMB_ICON = '' # TODO

  def search_bar_placeholder
    if @collection
      I18n.t 'search.bar.placeholder.collection', collection: @collection.display_title
    elsif controller.class.name.downcase =~ /collections/
      I18n.t 'search.bar.placeholder.collections'
    else
      I18n.t('search.bar.placeholder.default')
    end

  end

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

  # show thumbnail for item, or placeholder if none found
  def record_thumbnail(document, _options)
    url = case document['class_name_ss']
          when 'Item'
            "http://dlg.galileo.usg.edu/#{document['record_id_ss'].split('_')[0]}/#{document['record_id_ss'].split('_')[1]}/do-th:#{document['record_id_ss'].split('_')[2]}"
          when 'Collection'
            document['thumbnail_ss']
          else
            NO_THUMB_ICON
          end
    image_tag(url, class: 'thumbnail')
  end

  def spatial_cleaner(value)
    clean_value = value.gsub('United States, ', '')
    if value =~ COORDINATES_REGEXP
      clean_value.sub(COORDINATES_REGEXP, '')[0...-2]
    else
      # value contains no coordinates
      clean_value
    end
  end

  def link_to_collection_page(options)
    collection_title = options[:document][:collection_name_sms].first
    collection_record_id = options[:document][:id]
    link_to collection_title, collection_home_path(collection_record_id)
  end

  # overrides function in BL configuration_helper_behavior
  def collection_index_link_to(document)
    link_title = if document.key? 'dcterms_title_display'
                   document['dcterms_title_display'].first
                 else
                   I18n.t('collection.homepage_link')
                 end
    link_to link_title, collection_home_path(document['id'])
  end

  # When displaying an Item in the search results, use this to determine
  # the displayed title
  def item_title_display(document)
    default_link = link_to document['dcterms_title_display'].first, solr_document_path(document['record_id_ss'])
    title = if document.key? 'edm_is_shown_at_display'
              "#{default_link} [#{link_to('Open Item in New Window', document['edm_is_shown_at_display'].first, target: '_blank')}]"
            else
              default_link
            end
    title.html_safe
  end

  # Render icon for RS.org value
  # TODO: refactor/reconider use of I18n file for this purpose
  def rights_icon_tag(obj)
    I18n.t([:rights])[0].each do |r|
      if r[1][:uri] == obj[:value].first
        return link_to(
          image_tag(
            r[1][:icon_url],
            class: 'rights-statement-icon'
          ),
          r[1][:uri],
          class: 'rights-statement-link',
          target: '_blank'
        )
      end
    end
    link_to obj[:value].first, obj[:value].first
  end

  def collection_rights_icons(rights_array)
    image_tags = []
    I18n.t([:rights])[0].each do |r|
      set = false
      rights_array.each do |rights|
        next unless r[1][:uri] == rights
        image_tags << link_to(
          image_tag(
            r[1][:icon_url],
            class: 'rights-statement-icon'
          ),
          r[1][:uri],
          class: 'rights-statement-link',
          target: '_blank'
        )
        set = true
      end
      next unless set
    end
    image_tags.join('').html_safe
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
        str += link_to(I18n.t('collection.see_more'), solr_document_path(id))
        return str.html_safe
      end
      str += "#{v}<br />"
    end
    str.html_safe
  end

  def collection_external_homepage_link
    link_to I18n.t('collection.homepage_link'), @collection.is_shown_at.first, class: 'btn btn-primary'
  end

end