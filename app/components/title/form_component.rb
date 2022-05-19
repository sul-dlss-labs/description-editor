# frozen_string_literal: true

module Title
  class FormComponent < ViewComponent::Base
    def initialize(form:, url:, method:)
      @title_form = form
      @url = url
      @method = method
    end
  end
end
