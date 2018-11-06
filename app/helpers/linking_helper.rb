# frozen_string_literal: true

# Common helper methods for HTML link/button generating logic
module LinkingHelper
  def freely_available_path
    '/records?f%5Bclass_name%5D%5B%5D=Item&f_inclusive%5Brights_facet%5D%5B%5D=http%3A%2F%2Frightsstatements.org%2Fvocab%2FInC-NC%2F1.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=http%3A%2F%2Frightsstatements.org%2Fvocab%2FInC-RUU%2F1.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=http%3A%2F%2Frightsstatements.org%2Fvocab%2FNKC%2F1.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=http%3A%2F%2Frightsstatements.org%2Fvocab%2FNoC-NC%2F1.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=http%3A%2F%2Frightsstatements.org%2Fvocab%2FNoC-US%2F1.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=https%3A%2F%2Fcreativecommons.org%2Flicenses%2Fby-nc%2F4.0%2F&f_inclusive%5Brights_facet%5D%5B%5D=https%3A%2F%2Fcreativecommons.org%2Flicenses%2Fby%2F4.0%2F&search_field%3Dadvanced'
  end

  # handle linking in catalog results
  def linkify(options = {})
    url = options[:value].first
    link_to url, url, target: '_blank'
  end

  def regex_linkify(options = {})
    values = options[:value]
    values.map! do |v|
      URI.extract(v).each do |uri|
        v = v.sub(uri, link_to(uri, uri))
      end
      v
    end
    values.join('<br>').html_safe
  end

  def cache_server_image_link(v)
    "#{Rails.application.secrets.cache_server}#{v}"
  end

  # generate a link to a collection page using a collection document
  def link_to_collection_page(options)
    doc = options[:document]
    link_to doc.collection_title, collection_home_path(doc.id)
  end

  # generate link to collection page from an item document
  def item_link_to_collection_page(options)
    doc = options[:document]
    link_to doc.collection_title, collection_home_path(doc.collection_id)
  end

  # overrides function in BL configuration_helper_behavior
  def collection_index_link_to(document)
    link_title = if document.key? 'title'
                   document.title
                 else
                   I18n.t('collection.homepage_link')
                 end
    link_to link_title, collection_home_path(document.id), class: 'record-show-link'
  end

  # link to external site from a collection homepage
  def collection_external_homepage_link
    link_to(
      I18n.t('collection.homepage_link'),
      @collection.is_shown_at.first,
      class: 'btn btn-primary', target: '_blank'
    )
  end

  # show button for link to external collection page
  # TODO: check for local? value and display something else? not 'Partner'?
  def visit_partner_button(document)
    if document.md_url
      link_to(
        I18n.t('show.external_link'),
        document.md_url,
        class: 'btn btn-primary', target: '_blank'
      )
    else
      ''
    end
  end

  # render an individual RS link image
  def rights_statement_icon_link(rs_data)
    link_to(
      image_tag(rs_data[1][:icon_url], class: 'rights-statement-icon'),
      rs_data[1][:uri], class: 'rights-statement-link', target: '_blank'
    )
  end

  # render an icon for each RS associated with a collection
  def collection_rights_icons(rights_array)
    image_tags = []
    I18n.t([:rights])[0].each do |r|
      rights_array.each do |rights|
        next unless r[1][:uri] == rights
        image_tags << rights_statement_icon_link(r)
      end
    end
    image_tags.join('').html_safe
  end

  # render icon for RS value
  # TODO: refactor/reconider use of I18n file for this purpose
  def rights_icon_tag(obj)
    I18n.t([:rights])[0].each do |r|
      return rights_statement_icon_link(r) if r[1][:uri] == obj[:value].first
    end
    link_to obj[:value].first, obj[:value].first
  end
end