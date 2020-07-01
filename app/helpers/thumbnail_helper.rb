# frozen_string_literal: true

# Helpers for Thumbnails
module ThumbnailHelper

  # Return img tag for thumbnail with link
  def thumbnail_image_tag(document, options = {})
    options[:css] ||= 'thumbnail'
    case document.klass
    when 'Item'
      image_tag(item_thumb_url(document), class: options[:css])
    when 'Collection'
      image_tag(collection_thumb_url(document), class: "#{options[:css]} collection-image")
    else
      image_tag(no_thumb_url, class: options[:css])
    end
  rescue StandardError => e # TODO: ?
    image_tag(no_thumb_url, class: options[:css])
  end

  # Generate URL for Item or use standard Audio file icon
  def item_thumb_url(document)
    if sound_type_item?(document)
      asset_path 'file-audio.png'
    else
      "https://dlg.usg.edu/thumbnbails/#{document['repository_slug_ss']}/#{document['collection_slug_ss']}/#{document['record_id_ss']}.jpg"
    end
  end

  # On Item show pages, link thumbnail to DO if available, no link otherwise
  def show_item_thumb(document)
    if document.do_url
      link_to(
        thumbnail_image_tag(document, css: ''),
        document.do_url
      )
    else
      thumbnail_image_tag(document, css: '') + visit_partner_button(document)
    end
  end

  # Link index page item thumb to DO if present, show page otherwise
  def index_item_thumb(document)
    if document.do_url
      link_to(
        thumbnail_image_tag(document),
        document.do_url
      )
    else
      link_to(
        thumbnail_image_tag(document),
        solr_document_path(document.id)
      )
    end
  end

  # Check if collection has image set, return it or old style thumbnail URL
  # TODO: this check for dlg_default_image.png should be eliminated
  def collection_thumb_url(document)
    if document.image == '/dlg_default_image.png'
      document.thumbnail
    else
      cache_server_image_link document.image
    end
  end

  # Used in view to render index page thumbnail for Collections
  def index_collection_thumb(document)
    image = thumbnail_image_tag document
    link_to(
      image,
      collection_home_path(document.id)
    )
  end

  # Used in view to render collection thumb on show page
  def show_collection_thumb(document)
    if document.md_url
      link_to(
        thumbnail_image_tag(document),
        document.md_url
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
    document.types&.include?('Sound') &&
      document.item?
  end
end
