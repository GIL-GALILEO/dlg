# frozen_string_literal: true

# Contextual help helpers
module InstitutionsHelper
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
    if @institutions.length < 20
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
end
