# frozen_string_literal: true

module TitleComponents
  class NestedFormComponent < ViewComponent::Base
    def initialize(form:)
      @form = form
    end
  end
end
