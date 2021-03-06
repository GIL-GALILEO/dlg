# frozen_string_literal: true

# Contextual help helpers
module InstitutionsHelper
  def institution_description
    if @institution.description.present?
      @institution.description
    else
      @institution.short_description
    end
  end

  def institution_name
    if @institution.display_name.present?
      @institution.display_name
    else
      @institution.authorized_name
    end
  end

  def previous_page_paginator
    page = previous_page
    if page&.zero? || page.blank?
      ''
    else
      content_tag 'li' do
        link_to('<span aria-hidden="true">«</span>'.html_safe,
                page_link(page), 'aria-label': 'Previous')
      end
    end
  end

  def next_page_paginator
    # TODO: need to support a better means of hiding this link when no more records...
    page = next_page
    if @institution && @institution.length < 20
      ''
    else
      content_tag 'li' do
        link_to('<span aria-hidden="true">»</span>'.html_safe,
                page_link(page), 'aria-label': 'Previous')
      end
    end
  end

  def next_page
    if !params[:page] || params[:page] == '1'
      2
    elsif params[:page]
      params[:page].to_i + 1
    else
      1
    end
  end

  def previous_page
    params[:page].to_i - 1 if params[:page]
  end

  def page_link(page)
    institutions_path(request.query_parameters.merge(page: page))
  end

  def current_page
    params[:page] || '1'
  end

  # TODO: is this useful?
  def collection_results_link(inst, coll)
    facet_params = search_state.add_facet_params_and_redirect(
      'collection_titles_sms', coll.display_name
    )
    facet_params['f']['provenance_facet'] = [inst]
    search_action_path facet_params
  end

  def institution_results_link(inst)
    search_action_path(
      search_state.add_facet_params_and_redirect('provenance_facet', inst)
    )
  end

  def letter_link(l)
    txt = params[:letter] == l ? "<span class='badge'>#{l}</span>".html_safe : l
    link_to txt, institutions_path(letter: l)
  end

  def institution_types
    %w[All Archives State\ libraries Public\ libraries Museums University\ archives
       State\ agencies Presidential\ libraries Historical\ Societies]
  end

  def set_institution_page_title
    @page_title = "#{institution_name} - #{application_name}"
  end

  def institution_google_map_url
    # "https://www.google.com/maps/@?api=1&map_action=map&center=#{@institution.coordinates}"
    "https://www.google.com/maps/search/?api=1&query=#{URI.encode_www_form_component(institution_name)}"
  end
end
