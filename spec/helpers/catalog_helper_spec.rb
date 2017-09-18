require 'rails_helper'

RSpec.describe CatalogHelper do
  describe '#boolean_facet_labels' do
    it 'shows yes value for true' do
      expect(helper.boolean_facet_labels('true')).to match(/Yes/)
    end
    it 'shows no value for non-true values' do
      expect(helper.boolean_facet_labels('')).to match(/No/)
      expect(helper.boolean_facet_labels('false')).to match(/No/)
      expect(helper.boolean_facet_labels('0')).to match(/No/)
    end
  end

  describe '#truncate_index' do
    it 'truncates a value' do
      desc = ['A' * 5_000]
      expect(helper.truncate_index(
               value: desc
      )).to eq(
        "#{'A' * (2_500 - I18n.t('search.index.truncated_field').length)}#{I18n.t('search.index.truncated_field')}"
      )
    end
  end

  describe '#rights_icon_label' do
    it 'returns label corresponding to URI' do
      uri = I18n.t('rights.by-nc-nd.uri')
      expect(helper.rights_icon_label(uri)).to eq I18n.t('rights.by-nc-nd.label')
    end
    it 'returns the URI if lookup fails to find a label value' do
      uri = 'https://www.example.com'
      expect(helper.rights_icon_label(uri)).to eq uri
    end
  end

  describe '#record_thumbnail' do
    context 'for an Item' do
      it 'returns a thumbnail value containing a URL in do-th format' do
        item_doc = {
          'sunspot_id_ss' => 'Item 1',
          'slug_ss' => 'item1',
          'collection_slug_ss' => 'coll1',
          'repository_slug_ss' => 'repo1'
        }
        expect(record_thumbnail(item_doc, {})).to(
        include 'http://dlg.galileo.usg.edu/repo1/coll1/do-th:item1'
        )
      end
    end
    context 'for a Collection' do
      it 'returns a thumbnail value from the document' do
        item_doc = {
          'sunspot_id_ss' => 'Collection 1',
          'thumbnail_ss' => 'http://dlg.galileo.usg.edu/thumb.jpg'
        }
        expect(record_thumbnail(item_doc, {})).to(
          include 'http://dlg.galileo.usg.edu/thumb.jpg'
        )
      end
    end
    context 'for anything else' do
      it 'returns a thumbnail value from the document' do
        item_doc = {
          'sunspot_id_ss' => 'Repository 1'
        }
        expect(record_thumbnail(item_doc, {})).to(
          include 'no_thumb.gif'
        )
      end
    end

  end

  describe '#spatial_cleaner' do
    it 'returns a string devoid of coordinates' do
      value = 'United States, Georgia, Clarke County, Athens, 33.960948, -83.3779358'
      expect(spatial_cleaner(value)).to eq 'United States, Georgia, Clarke County, Athens'
    end
  end
end