# frozen_string_literal: true

module TitleComponents
  class FormComponent < ViewComponent::Base
    def initialize(model:, url:, method:)
      @model = model
      @url = url
      @method = method
    end
  end
end
