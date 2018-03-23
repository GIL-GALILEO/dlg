# frozen_string_literal: true

# Helpers for Thumbnails
module ThumbnailHelper

  # Return img tag for thumbnail with link
  def thumbnail_image_tag(document)
    case document['class_name_ss']
    when 'Item'
      image_tag(item_thumb_url(document), class: 'thumbnail')
    when 'Collection'
      image_tag(collection_thumb_url(document), class: 'thumbnail collection-image')
    else
      image_tag(no_thumb_url, class: 'thumbnail')
    end
  rescue StandardError # TODO: ?
    image_tag(no_thumb_url, class: 'thumbnail')
  end

  # Generate URL for Item or use standard Audio file icon
  def item_thumb_url(document)
    if sound_type_item?(document)
      asset_path 'file-audio.png'
    else
      "http://dlg.galileo.usg.edu/#{document['record_id_ss'].split('_')[0]}/#{document['record_id_ss'].split('_')[1]}/do-th:#{document['record_id_ss'].split('_')[2]}"
    end
  end

  # On Item show pages, link thumbnail to DO if available, no link otherwise
  def show_item_thumb(document)
    if do_url? document
      link_to(
        thumbnail_image_tag(document),
        do_url_for(document),
        target: '_blank'
      )
    else
      thumbnail_image_tag(document) + visit_partner_button(document)
    end
  end

  # Link index page item thumb to DO if present, show page otherwise
  def index_item_thumb(document)
    if do_url? document
      link_to(
        thumbnail_image_tag(document),
        do_url_for(document), target: '_blank'
      )
    else
      link_to(
        thumbnail_image_tag(document),
        solr_document_path(identifier_for(document))
      )
    end
  end

  # Check if collection has image set, return it or old style thumbnail URL
  # TODO: this check for dlg_default_image.png should be eliminated
  def collection_thumb_url(document)
    if document['image_ss'] == '/dlg_default_image.png'
      document['thumbnail_ss']
    else
      cache_server_image_link document['image_ss']
    end
  end

  # Used in view to render index page thumbnail for Collections
  def index_collection_thumb(document)
    link_to(
      thumbnail_image_tag(document),
      collection_home_path(identifier_for(document))
    )
  end

  # Used in view to render collection thumb on show page
  def show_collection_thumb(document)
    if md_url? document
      link_to(
        thumbnail_image_tag(document),
        md_url_for(document),
        target: '_blank'
      )
    else
      # No other link available, so link thumb to internal collection homepage
      index_collection_thumb(document)
    end
  end

  def no_thumb_url
    asset_path 'no-thumb.png'
  end

  def sound_type_item?(document)
    document['dcterms_type_display']&.include?('Sound') &&
      document['class_name_ss'] == 'Item'
  end
end
