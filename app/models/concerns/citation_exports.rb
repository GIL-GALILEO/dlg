# frozen_string_literal: true

# Module for enabling record citation styles
module CitationExports
  extend ActiveSupport::Concern

  def export_as_chicago_citation_txt
    "#{author_value}. \"#{citation_value 'dcterms_title_display'}.\" #{date_value}. #{accessed_date}. #{record_url}."
  end

  def export_as_mla_citation_txt
    "#{author_value}. \"#{citation_value 'dcterms_title_display'}.\" #{citation_value 'dcterms_provenance_display'}. #{date_value}, #{record_url}."
  end

  def export_as_apa_citation_txt
    "#{author_value} (#{date_value}). #{citation_value 'dcterms_title_display'}. Retrieved from #{record_url}"
  end

  private

  def date_value
    if self['dc_date_display'].present?
      citation_value 'dc_date_display'
    else
      I18n.t('show.tools.citation.date_value_unavailable')
    end
  end

  def citation_value(array_field, placeholder = nil)
    if key?(array_field) && self[array_field].present?
      self[array_field].first
    else
      placeholder || I18n.t('show.tools.citation.field_value_unavailable')
    end
  end

  def author_value
    if key? 'dcterms_creator_display'
      citation_value 'dcterms_creator_display'
    elsif key? 'dcterms_publisher_display'
      citation_value 'dcterms_publisher_display'
    else
      I18n.t('show.tools.citation.field_value_unavailable')
    end
  end

  def accessed_date
    DateTime.now.strftime '%B %e, %Y'
  end

  def record_url
    if key? 'edm_is_shown_by_display'
      citation_value('edm_is_shown_by_display')
    elsif key? 'edm_is_shown_at_display'
      citation_value('edm_is_shown_at_display')
    else
      Rails.application.routes.url_helpers.solr_document_path(self['id'])
    end
  end

end