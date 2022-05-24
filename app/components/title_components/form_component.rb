# frozen_string_literal: true

module TitleComponents
  class FormComponent < ViewComponent::Base
    def initialize(model:, url:, method:)
      @model = model
      @url = url
      @method = method
    end

    def type_choices
      CocinaDescriptionTypes.types_for('title')
    end
  end
end
