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

  # show thumbnail for item, or placeholder if none found
  def thumbnail_image_tag(document)
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

  def index_collection_thumb(document)
    link_to thumbnail_image_tag(document), collection_home_path(identifier_for(document))
  end

  def index_item_thumb(document)
    # go to DO in new window if present, show page otherwise
    if do_url? document
      link_to thumbnail_image_tag(document), do_url_for(document), target: '_blank'
    else
      link_to thumbnail_image_tag(document), solr_document_path(identifier_for(document))
    end
  end

  def show_collection_thumb(document)
    # link to partner site, if available, collection homepage otherwise
    if md_url? document
      link_to thumbnail_image_tag(document), md_url_for(document), target: '_blank'
    else
      index_collection_thumb(document)
    end
  end

  def show_item_thumb(document)
    # link to DO if available, no link otherwise
    if do_url? document
      link_to thumbnail_image_tag(document), do_url_for(document), target: '_blank'
    else
      thumbnail_image_tag(document)
    end
  end

  def collection_external_homepage_link
    link_to I18n.t('collection.homepage_link'), @collection.is_shown_at.first, class: 'btn btn-primary'
  end

  def do_url?(document)
    document.key?('edm_is_shown_by_display') && document['edm_is_shown_by_display'].first =~ URI.regexp
  end

  def md_url?(document)
    document.key?('edm_is_shown_at_display') && document['edm_is_shown_at_display'].first =~ URI.regexp
  end

  def do_url_for(document)
    document['edm_is_shown_by_display'].first
  end

  def md_url_for(document)
    document['edm_is_shown_at_display'].first
  end

  def identifier_for(document)
    document['record_id_ss']
  end

end