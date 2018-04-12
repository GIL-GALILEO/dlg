# frozen_string_literal: true

# Helpers for Thumbnails
module ThumbnailHelper

  # Return img tag for thumbnail with link
  def thumbnail_image_tag(document)
    case document.klass
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
      parts = document.id.split('_')
      "http://dlg.galileo.usg.edu/#{parts[0]}/#{parts[1]}/do-th:#{parts[2]}"
    end
  end

  # On Item show pages, link thumbnail to DO if available, no link otherwise
  def show_item_thumb(document)
    if document.do_url
      link_to(
        thumbnail_image_tag(document),
        document.do_url,
        target: '_blank'
      )
    else
      thumbnail_image_tag(document) + visit_partner_button(document)
    end
  end

  # Link index page item thumb to DO if present, show page otherwise
  def index_item_thumb(document)
    if document.do_url
      link_to(
        thumbnail_image_tag(document),
        document.do_url, target: '_blank'
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

  def vang_image
    '/uploads/repository/71/image/feature_image.png'
  end

  # Used in view to render index page thumbnail for Collections
  # # TODO: avoid this awful hack to display special image for vang
  def index_collection_thumb(document)
    image = collection_image_tag document
    link_to(
      image,
      collection_home_path(document.id)
    )
  end

  def collection_image_tag(document)
    if document.id == 'dlg_vang'
      image_tag(cache_server_image_link(vang_image), class: 'thumbnail collection-image')
    else
      thumbnail_image_tag(document)
    end
  end

  # Used in view to render collection thumb on show page
  def show_collection_thumb(document)
    if document.md_url
      link_to(
        collection_image_tag(document),
        document.md_url,
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
    document.types&.include?('Sound') &&
      document.item?
  end
end
