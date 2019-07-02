# frozen_string_literal: true

require 'rails_helper'

feature 'Collections' do
  include ApiV2Helpers

  context 'collection search page' do
    before(:each) { visit search_collections_path }
    context 'search bar' do
      scenario 'uses collection search URL' do
        expect(page).to have_css("form[action='#{search_collections_url}']")
      end
      scenario 'has a placeholder indicating it searches Collections' do
        expect(page).to have_css("input[placeholder='#{I18n.t('search.bar.placeholder.collections')}']")
      end
    end
    context 'results area' do
      scenario 'defaults to list view' do
        expect(page).to have_css('a.view-type-list.active')
      end
    end
    context 'range facet plugin', js: true do
      before(:each) { find('div.blacklight-year_facet').click }
      scenario 'slider is shown' do
        expect(page).to have_css('div.slider.slider-horizontal')
      end
      scenario 'date inputs for range are shown' do
        expect(page).to have_css('#range_year_facet_begin')
        expect(page).to have_css('#range_year_facet_end')
      end
      scenario 'flot histogram is shown' do
        expect(page).to have_css('canvas.flot-overlay')
      end
      scenario 'limiting to a range shows constraint in constraint area' do
        click_button(I18n.t('blacklight.range_limit.submit_limit'))
        within '#appliedParams' do
          expect(page).to have_text I18n.t('search.facets.year')
        end
      end
    end
  end
  context 'collection home page' do
    before(:each) do
      stub_collection_request
      visit collection_home_path 'dlg_vsbg'
    end
    context 'results list' do
      # check that items that are members of a collection via the
      # 'other_collection' values in DLG Admin are included in search results
      # that limit based on collection_titles_sms. see models/records_search
      scenario 'includes items based on other_collection values', js: true do
        expect(page).to have_text 'Map of Dade County'
      end
    end
    context 'more about panel' do
      scenario 'shows '
    end
    context 'resources panel', js: true do
      scenario 'lists links to provided resources' do
        within '.resources-panel' do
          click_on 'Additional Resources'
          expect(page).to have_link('One', href: '/collections/dlg_vsbg/one')
          expect(page).to have_link('Two', href: '/collections/dlg_vsbg/two')
        end
      end
    end
    context 'search bar' do
      scenario 'has a placeholder indicating it searches over the collection' do
        placeholder_text = I18n.t(
          'search.bar.placeholder.collection',
          collection: 'Liberty Ships'
        )
        expect(page).to have_css("input[placeholder='#{placeholder_text}']")
      end
    end
  end
end