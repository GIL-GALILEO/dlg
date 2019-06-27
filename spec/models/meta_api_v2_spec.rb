# frozen_string_literal: true

require 'rails_helper'

describe MetaApiV2 do
  let(:apiv2) { MetaApiV2.new }
  context 'features' do
    let(:successful_response) do
      '[
         {"id":1,
          "title":".Feature 1",
          "title_link":"https://link.com",
          "institution":"Institution",
          "institution_link":"https://link.institution.com",
          "short_description":"Short Description",
          "external_link":"https://external.link.com",
          "primary":true,
          "image":{"url":"/uploads/feature/1/image/record_image.gif"},
          "area":"tabs",
          "large_image":{"url":"/uploads/feature/1/large_image/record_image.gif"},
          "public":true,
          "created_at":"2019-01-01T12:00:00.000-04:00",
          "updated_at":"2019-01-01T12:00:00.000-04:00"},
         {"id":2,
          "title":".Feature 2",
          "title_link":"https://link.com",
          "institution":"Institution",
          "institution_link":"https://link.institution.com",
          "short_description":"Short Description",
          "external_link":"https://external.link.com",
          "primary":true,
          "image":{"url":"/uploads/feature/2/image/record_image.gif"},
          "area":"tabs",
          "large_image":{"url":"/uploads/feature/2/large_image/record_image.gif"},
          "public":true,
          "created_at":"2019-01-01T12:00:00.000-04:00",
          "updated_at":"2019-01-01T12:00:00.000-04:00"}
      ]'
    end
    subject(:tab_features) do
      stub_request(:get, 'https://test.api/features?portal=georgia&type=tab')
        .with(headers: { 'X-User-Token' => 'test_api_key' })
        .to_return(
          status: 200, body: successful_response,
          headers: { 'Content-Type' => 'application/json' }
        )
      apiv2.features(type: 'tab')
    end
    it 'returns an array of feature objects for tabs' do
      required_keys = %w[primary large_image title title_link institution institution_link short_description]
      expect(tab_features.length).to eq 2
      expect(tab_features.first).to respond_to(*required_keys)
    end
  end
  context 'holding institutions' do
    context 'single record' do
      let(:successful_response) do
        '{"id":1,
          "authorized_name":"Institution Name",
          "short_description":"Institution Description",
          "description":"Long Institution Description",
          "image":{"url":"/uploads/holding_institution/1/image/record_image.gif"},
          "homepage_url":"https://institution.com",
          "coordinates":"31.000000, -80.000000",
          "strengths":"Strengths",
          "public_contact_address":"Public Address",
          "institution_type":"Type",
          "galileo_member":true,
          "created_at":"2019-01-01T12:00:00.000-04:00",
          "updated_at":"2019-01-01T12:00:00.000-04:00",
          "parent_institution":"Parent Institution",
          "display_name":"Display Institution Name",
          "slug":"institution-slug",
          "public":true,
          "public_contact_email":"public_contact@institution.com",
          "public_contact_phone":"(111) 123-4567",
          "public_collections":[]
         }'
      end
      subject(:holding_institution) do
        stub_request(:get, 'https://test.api/holding_institutions/dlg?portal=georgia')
          .with(headers: { 'X-User-Token' => 'test_api_key' })
          .to_return(
            status: 200, body: successful_response,
            headers: { 'Content-Type' => 'application/json' }
          )
        apiv2.holding_institution('dlg')
      end
      context 'for a single holing institution' do
        it 'get by ID' do
          expect(holding_institution).to respond_to 'authorized_name'
          expect(holding_institution).to respond_to 'display_name'
          expect(holding_institution.image['url'])
            .to include 'record_image'
        end
      end
    end
    context 'for many holding institutions' do
      let(:successful_response) do
        '[{"id":1,
          "authorized_name":"Institution Name",
          "short_description":"Institution Description",
          "description":"Long Institution Description",
          "image":{"url":"/uploads/holding_institution/1/image/record_image.gif"},
          "homepage_url":"https://institution.com",
          "coordinates":"31.000000, -80.000000",
          "strengths":"Strengths",
          "public_contact_address":"Public Address",
          "institution_type":"Type",
          "galileo_member":true,
          "created_at":"2019-01-01T12:00:00.000-04:00",
          "updated_at":"2019-01-01T12:00:00.000-04:00",
          "parent_institution":"Parent Institution",
          "display_name":"Display Institution Name",
          "slug":"institution-slug-1",
          "public":true,
          "public_contact_email":"public_contact@institution.com",
          "public_contact_phone":"(111) 123-4567",
          "public_collections":[]
         },
         {"id":2,
          "authorized_name":"Institution Name",
          "short_description":"Institution Description",
          "description":"Long Institution Description",
          "image":{"url":"/uploads/holding_institution/1/image/record_image.gif"},
          "homepage_url":"https://institution.com",
          "coordinates":"31.000000, -80.000000",
          "strengths":"Strengths",
          "public_contact_address":"Public Address",
          "institution_type":"Type",
          "galileo_member":true,
          "created_at":"2019-01-01T12:00:00.000-04:00",
          "updated_at":"2019-01-01T12:00:00.000-04:00",
          "parent_institution":"Parent Institution",
          "display_name":"Display Institution Name",
          "slug":"institution-slug-2",
          "public":true,
          "public_contact_email":"public_contact@institution.com",
          "public_contact_phone":"(111) 123-4567",
          "public_collections":[]
         }]'
      end
      before(:each) do
        stub_request(:get, /holding_institutions/)
          .with(headers: { 'X-User-Token' => 'test_api_key' })
          .to_return(
            status: 200, body: successful_response,
            headers: { 'Content-Type' => 'application/json' }
          )
      end
      it 'returns an array of objects' do
        holding_institutions = apiv2.holding_institutions
        expect(holding_institutions.length).to eq 2
        expect(holding_institutions.first).to be_a OpenStruct
        expect(holding_institutions.first).to respond_to :authorized_name
      end
      it 'handles pagination params' do
        apiv2.holding_institutions per_page: 1, page: 1
        expect(
          a_request(:get, 'https://test.api/holding_institutions?page=1&per_page=1&portal=georgia')
            .with(headers: { 'X-User-Token' => 'test_api_key' })
        ).to have_been_made
      end
      it 'handles inst_type filter' do
        apiv2.holding_institutions type: 'Museums'
        expect(
          a_request(:get, 'https://test.api/holding_institutions?&portal=georgia&type=Museums')
            .with(headers: { 'X-User-Token' => 'test_api_key' })
        ).to have_been_made
      end
      it 'handles letter filter' do
        apiv2.holding_institutions letter: 'G'
        expect(
          a_request(:get, 'https://test.api/holding_institutions?&portal=georgia&letter=G')
            .with(headers: { 'X-User-Token' => 'test_api_key' })
        ).to have_been_made
      end
    end
  end
  context 'collection method' do
    let(:successful_response) do
      '{"id":1,
        "display_title":"Liberty Ships",
        "short_description":"Description of Liberty Ships",
        "dc_right":["https://creativecommons.org/publicdomain/zero/1.0/"],
        "dc_date":["1943/1945"],
        "dcterms_creator":["J.A. Jones Construction Company "],
        "dcterms_description":["Long description"],
        "dcterms_medium":["Aerial photographs, Black-and-white photographs"],
        "dcterms_spatial":["United States, Georgia, Glynn County, Brunswick, 31.1499528, -81.4914894"],
        "dcterms_subject":["Liberty ships--Georgia--Brunswick","Shipbuilding industry--Georgia--Brunswick"],
        "dcterms_title":["Liberty Ships of Georgia"],
        "dcterms_type":["Collection"],
        "edm_is_shown_at":["https://url.com"],
        "items_count":44,
        "record_id":"dlg_vsbg",
        "edm_is_shown_by":["https://url.com"],
        "collection_resources_count":"2",
        "sponsor_note":"Sponsor Note",
        "sponsor_image":{"url":"/uploads/collection/1/sponsor_image/record_image.jpg"},
        "dcterms_provenance":[""],
        "holding_institution_image":"/uploads/holding_institution/1/image/record_image.gif",
        "portals":[{"id":1,"code":"dlg","name":"Digital Library of Georgia"}],
        "collection_resources":[
          {"slug":"one","position":1,"title":"One"},
          {"slug":"two","position":2,"title":"Two"}
        ],
        "holding_institutions":[
          {"authorized_name":"HI1",
           "image":{"url":"/uploads/holding_institution/1/image/record_image.gif"},
           "display_name":"HI1"},
          {"authorized_name":"HI2",
           "image":{"url":"/uploads/holding_institution/2/image/record_image.gif"},
           "display_name":"HI2"}
        ]}'
    end
    subject(:collection) do
      collection_record_id = 'dlg_vsbg'
      stub_request(:get, 'https://test.api/collections/dlg_vsbg?portal=georgia')
        .with(headers: { 'X-User-Token' => 'test_api_key' })
        .to_return(
          status: 200, body: successful_response,
          headers: { 'Content-Type' => 'application/json' }
        )
      apiv2.collection(collection_record_id)
    end
    it 'returns basic collection information' do
      expect(collection).to respond_to 'display_title'
    end
    it 'returns holding institution information' do
      expect(collection.holding_institutions.first).to have_key 'display_name'
      expect(collection.holding_institutions.first).to have_key 'image'
    end
    it 'returns holding collection resource information' do
      expect(collection.collection_resources.first).to have_key 'slug'
      expect(collection.collection_resources.first).to have_key 'title'
      expect(collection.collection_resources.first).to have_key 'position'
    end
  end
  context 'collection resource information' do
    let(:successful_response) do
      '{"id":1,
        "slug":"bibliography",
        "position":"1",
        "title":"Bibliography",
        "content":"Bibliographic content.",
        "created_at":"2019-01-01T12:00:00.000-00:00",
        "updated_at":"2019-01-01T12:00:52.000-00:00",
        "collection":
          {"display_title":"Liberty Ships",
           "record_id":"dlg_vsbg"}
        }'
    end
    subject(:collection_resource) do
      collection_record_id = 'dlg_vsbg'
      collection_resource_slug = 'bibliography'
      stub_request(:get, 'https://test.api/collections/dlg_vsbg/resource/bibliography?portal=georgia')
        .to_return(
          status: 200, body: successful_response,
          headers: { 'Content-Type' => 'application/json' }
        )
      apiv2.collection_resource(collection_record_id, collection_resource_slug)
    end
    it 'return collection_resource information' do
      expect(collection_resource).to respond_to :content, :position
    end
  end
end