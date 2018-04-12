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
