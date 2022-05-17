# frozen_string_literal: true

module Title
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title

    def initialize(title:, title_counter:)
      @title = title.with_indifferent_access
      @index = title_counter - 1
    end
  end
end
