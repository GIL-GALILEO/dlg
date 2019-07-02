# frozen_string_literal: true

# helper methods for RecordsController views
module RecordsHelper
  def set_page_title
    prefix = if @collection && !has_search_parameters?
               "#{@collection.display_title} Collection Items"
             elsif @collection && has_search_parameters?
               "#{render_search_to_page_title(params)} - #{@collection.display_title} Collection Items"
             end
    @page_title = "#{prefix} - #{application_name}"
  end

  def collection_limited_results?
    @collection && @document_list.any?
  end

  def collection_holding_institutions_text
    if @collection.holding_institutions
      @collection.holding_institutions.map do |hi|
        hi['display_name']
      end.to_sentence.html_safe
    else
      @collection.dcterms_provenance.first
    end
  end

  def multivalued_collection_field(field, connector = ', ')
    return '' unless @collection.respond_to? field

    @collection.send(field).map.to_a
               .to_sentence(two_words_connector: connector).html_safe
  end

  def collection_subject_links
    links = []
    @collection.dcterms_subject.each do |subj|
      links << link_to(subj, search_action_path(
                               search_state.add_facet_params_and_redirect(
                                 'subject_facet', subj
                               )
                             ))
    end
    links.to_sentence.html_safe
  end

  def collection_location_links
    links = []
    @collection.dcterms_spatial.each do |loc|
      links << link_to(loc, search_action_path(
                              search_state.add_facet_params_and_redirect(
                                'location_facet', loc
                              )
                            ))
    end
    links.to_sentence.html_safe
  end

  def rights_statement_icons
    image_tags = []
    I18n.t([:rights])[0].each do |r|
      @collection.dc_right.each do |rights|
        next unless r[1][:uri] == rights
        image_tags << rights_statement_icon_link(r)
      end
    end
    image_tags.join('').html_safe
  end

  def collection_field_tag(label, field_value)
    tag.p(tag.strong(label) + tag.br + field_value)
  end
end