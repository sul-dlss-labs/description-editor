# frozen_string_literal: true

module TitleComponents
  class AddComponent < ViewComponent::Base
    def initialize(description_id:)
      @description_id = description_id
    end
  end
end
