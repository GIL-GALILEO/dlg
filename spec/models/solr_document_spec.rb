# frozen_string_literal: true

require 'rails_helper'

describe SolrDocument do
  context 'for an Item' do
    subject(:solr_document) do
      described_class.new(
        'id': 'dlg_children_acl2048',
        'class_name_ss': 'Item',
        'local_ss': '1',
        'slug_ss': 'acl2048',
        'record_id_ss': 'dlg_children_acl2048',
        'collection_record_id_ss': 'dlg_children',
        'collection_record_id_sms': ['dlg_children', 'gaarchives_hdg'],
        'collection_slug_ss': 'children',
        'collection_titles_sms': ['Life of the Child in American Society', 'Historic Documents of Georgia'],
        'portals_sms': ['georgia'],
        'dcterms_provenance_display': ['Athens-Clarke County Library (Athens, Ga.)'],
        'dcterms_title_display': ['A chapter of child health, Clarke County, Georgia, 1930'],
        'dcterms_creator_display': ['Commonwealth Fund'],
        'dcterms_subject_display': ['Public health--Georgia--Clarke County', 'Commonwealth Fund', 'Community health services--Georgia--Clarke County', 'School hygiene--Georgia--Clarke County', 'School health services--Georgia--Clarke County', 'Child health services--Georgia--Clarke County', 'Community health services for children--Georgia--Clarke County', 'Children--Health and hygiene'],
        'dcterms_description_display': ['A chapter of child health: Report of the Commonwealth Fund child health demonstration in Clarke County and Athens, Georgia, 1924-1928. Book describes efforts by the Commonwealth Fund to strengthen public health services, particularly for children, in Clarke County, Georgia.'],
        'edm_is_shown_at_display': ['http://dlg.galileo.usg.edu/id:dlg_children_acl2048'],
        'edm_is_shown_by_display': ['http://dlg.galileo.usg.edu/children/do:acl2048'],
        'dc_date_display': ['1930'],
        'dcterms_spatial_display': ['United States, Georgia, Clarke County, Athens, 33.960948, -83.3779358'],
        'dc_format_display': ['application/pdf'],
        'dc_right_display': ['http://rightsstatements.org/vocab/NoC-US/1.0/'],
        'dcterms_type_display': ['Text'],
        'dcterms_medium_display': ['Reports'],
        'dcterms_language_display': ['eng'],
        'title': 'A chapter of child health, Clarke County, Georgia, 1930'
      )
    end
    it 'has convenience methods' do
      expect(subject.id).to eq 'dlg_children_acl2048'
      expect(subject.item?).to be_truthy
      expect(subject.klass).to eq 'Item'
      expect(subject.title).to eq 'A chapter of child health, Clarke County, Georgia, 1930'
      expect(subject.image).to be_nil
      expect(subject.thumbnail).to be_nil
      expect(subject.types).to eq ['Text']
      expect(subject.do_url).to eq 'http://dlg.galileo.usg.edu/children/do:acl2048'
      expect(subject.md_url).to eq 'http://dlg.galileo.usg.edu/id:dlg_children_acl2048'
      expect(subject.collection_id).to eq 'dlg_children'
      expect(subject.collection_title).to eq 'Life of the Child in American Society'
    end
  end
  context 'for a Collection' do
    subject(:solr_document) do
      described_class.new(
        'id': 'gaarchives_cmf',
        'class_name_ss': 'Collection',
        'slug_ss': 'cmf',
        'record_id_ss': 'gaarchives_cmf',
        'thumbnail_ss': 'http://dlg.galileo.usg.edu/do-th:gaarchives',
        'portals_sms': ['georgia'],
        'display_title_display': ['County Maps'],
        'short_description_display': ['State-produced maps of Georgia counties from 1866 to 1935.'],
        'dcterms_title_display': ['County maps'],
        'dcterms_subject_display': ['Georgia--Maps'],
        'dcterms_description_display': ['The County Map File consists of maps of Georgia\'s 161 (now 159) counties collected by the Office of Surveyor General. Many of the maps in this collection were produced under the direction of the state between 1866 - 1935, including those created by Acts of the General Assembly and the State Highway Department; some maps were created in conjunction with the United States Post Office Department and the Department of Agriculture. The several types of county maps show cities, towns, roads and highways, watercourses, and other geographic and topographic features.'],
        'edm_is_shown_at_display': ['http://cdm.georgiaarchives.org:2011/cdm/landingpage/collection/cmf'],
        'dc_date_display': ['1866/1935'],
        'dc_right_display': ['http://rightsstatements.org/vocab/CNE/1.0/'],
        'dcterms_medium_display': ['Maps', 'Visual works'],
        'image_ss': '/uploads/repository/46/image/feature_image.png',
        'title': 'County maps'
      )
    end
    it 'has convenience methods' do
      expect(subject.id).to eq 'gaarchives_cmf'
      expect(subject.item?).to be_falsey
      expect(subject.klass).to eq 'Collection'
      expect(subject.title).to eq 'County maps'
      expect(subject.image).to eq'/uploads/repository/46/image/feature_image.png'
      expect(subject.thumbnail).to eq 'http://dlg.galileo.usg.edu/do-th:gaarchives'
      expect(subject.types).to be_nil
      expect(subject.do_url).to be_nil
      expect(subject.md_url).to eq 'http://cdm.georgiaarchives.org:2011/cdm/landingpage/collection/cmf'
      expect(subject.collection_id).to be_nil
      expect(subject.collection_title).to be_nil
    end
  end
end