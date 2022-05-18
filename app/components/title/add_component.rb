# frozen_string_literal: true

module Title
  class AddComponent < ViewComponent::Base
    def initialize(description_id:)
      @description_id = description_id
    end
  end
end
