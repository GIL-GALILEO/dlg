# frozen_string_literal: true

# helper methods for Blacklight catalog pages
module CatalogHelper
  include Blacklight::CatalogHelperBehavior
  COORDINATES_REGEXP = /(-?\d+\.\d+), (-?\d+\.\d+)/
  INDEX_TRUNCATION_VALUE = 2500

  def search_bar_placeholder
    if @collection
      I18n.t 'search.bar.placeholder.collection', collection: @collection.display_title
    elsif @institution
      I18n.t 'search.bar.placeholder.institution', institution: @institution.authorized_name
    elsif controller.class.name.downcase =~ /collections/
      I18n.t 'search.bar.placeholder.collections'
    else
      I18n.t('search.bar.placeholder.default')
    end
  end

  # find current search type in fields array and return display label
  def search_type_label
    type = search_fields.find do |f|
      (f[1] == params['search_field']) || (f[1] == 'both')
    end
    I18n.t('blacklight.search.form.search.prefix') + ' ' + type[0]
  end

  # show search bar options only on homepage and record search
  def show_search_bar_options
    zone = controller.class.name.downcase
    zone =~ /homepage/ || zone =~ /records/
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

  # related to show page tabs
  def show_tabs?(document = @document)
    document.fulltext || document.iiif_ids
  end

  def iiif_manifest_urls(document = @document)
    iiif_prefix = Rails.application.secrets.iiif_prefix
    @document.iiif_ids&.map do |id|
      iiif_prefix + id
    end
  end
end