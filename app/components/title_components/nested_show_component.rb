# frozen_string_literal: true

module TitleComponents
  class NestedShowComponent < ViewComponent::Base
    def initialize(title_model:)
      @title_model = title_model
    end

    def title
      @title_model
    end
  end
end
