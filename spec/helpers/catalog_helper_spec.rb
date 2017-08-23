require 'rails_helper'

RSpec.describe CatalogHelper, type: :helper do
  describe '#boolean_facet_labels' do
    it 'shows yes value for true' do
      expect(helper.boolean_facet_labels('true')).to match /Yes/
    end
    it 'shows no value for non-true values' do
      expect(helper.boolean_facet_labels('')).to match /No/
      expect(helper.boolean_facet_labels('false')).to match /No/
      expect(helper.boolean_facet_labels('0')).to match /No/
    end
  end

  describe '#truncate_index' do
    it 'truncates a value' do
      desc = ['A' * 5_000]
      expect(helper.truncate_index(
          {value: desc}
      )).to eq(
                "#{'A' * (2_500 - I18n.t('search.index.truncated_field').length)}#{I18n.t('search.index.truncated_field')}"
            )
    end
  end
end