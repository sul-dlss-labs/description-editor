# frozen_string_literal: true

module TitleComponents
  class NestedFormComponent < ViewComponent::Base
    def initialize(form:)
      @form = form
    end

    def type_choices
      CocinaDescriptionTypes.types_for('title.structuredValue')
    end
  end
end
