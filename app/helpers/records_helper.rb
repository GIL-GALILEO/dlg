# frozen_string_literal: true

# helper methods for RecordsController
module RecordsHelper
  def institution_description
    description = if @institution.description.present?
                    @institution.description
                  else
                    @institution.short_description
                  end
    strip_tags description
  end

  def institution_name
    if @institution.display_name.present?
      @institution.display_name
    else
      @institution.authorized_name
    end
  end
end