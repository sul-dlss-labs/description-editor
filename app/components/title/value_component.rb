# frozen_string_literal: true

module Title
  class ValueComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end

    def value
      @title[:value]
    end
  end
end
