# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument
  include CitationExports
  # self.unique_key = 'id'
  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)
  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)
  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  field_semantics.merge!(
    contributor: 'dcterms_contributor_display',
    coverage: 'dcterms_spatial_display',
    creator: 'dcterms_creator_display',
    date: 'dc_date_display',
    description: 'dcterms_description_display',
    provenance: 'dcterms_provenance_display',
    format: 'dc_format_display',
    identifier: 'dcterms_identifier_display',
    language: 'dcterms_language_display',
    publisher: 'dcterms_publisher_display',
    relation: 'dc_relation_display',
    rights: 'dc_right_display',
    source: 'dcterms_is_part_of_display',
    subject: 'dcterms_subject_display',
    title: 'dcterms_title_display',
    type: 'dcterms_type_display'
  )

  def as_json(_)
    {
      id: id,
      title: title,
      collection_id: collection_id,
      collection_title: collection_title,
      dcterms_contributor: self['dcterms_contributor_display'],
      dcterms_spatial: self['dcterms_spatial_display'],
      dcterms_creator: self['dcterms_creator_display'],
      dc_date: self['dc_date_display'],
      dcterms_description: self['dcterms_description_display'],
      dc_format: self['dc_format_display'],
      dcterms_identifier: self['dcterms_identifier_display'],
      dcterms_language: self['dcterms_language_display'],
      dcterms_publisher: self['dcterms_publisher_display'],
      dc_relation: self['dc_relation_display'],
      dc_right: self['dc_right_display'],
      dcterms_is_part_of: self['dcterms_is_part_of_display'],
      dcterms_subject: self['dcterms_subject_display'],
      dcterms_title: self['dcterms_title_display'],
      dcterms_type: self['dcterms_type_display'],
      dcterms_provenance: self['dcterms_provenance_display'],
      edm_is_shown_by: self['edm_is_shown_by_display'],
      edm_is_shown_at: self['edm_is_shown_at_display'],
      dcterms_temporal: self['dcterms_temporal_display'],
      dcterms_rights_holder: self['dcterms_rights_holder_display'],
      dcterms_bibliographic_citation: self['dcterms_bibliographic_citation_display'],
      dlg_local_right: self['dlg_local_right_display'],
      dcterms_medium: self['dcterms_medium_display'],
      dcterms_extent: self['dcterms_extent_display'],
      dlg_subject_personal: self['dlg_subject_personal_display'],
      fulltext: fulltext
    }
  end

  def klass
    self[:class_name_ss]
  end

  def item?
    klass == 'Item'
  end

  def title
    self[:title]
  end

  def image
    self[:image_ss]
  end

  def thumbnail
    self[:thumbnail_ss]
  end

  def fulltext
    self[:fulltext_texts]&.reject(&:blank?) ? self[:fulltext_texts].first : nil
  end

  def iiif_ids
    self[:iiif_ids_sms]
  end

  def types
    self[:dcterms_type_display]
  end

  def do_url
    self[:edm_is_shown_by_display]&.first
  end

  def md_url
    self[:edm_is_shown_at_display]&.first
  end

  def collection_title
    self[:collection_titles_sms]&.first
  end

  def collection_id
    self[:collection_record_id_sms]&.first
  end
end
