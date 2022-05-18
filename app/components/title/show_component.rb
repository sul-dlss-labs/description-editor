# frozen_string_literal: true

module Title
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title

    def initialize(description_id:, title:, title_counter:)
      @title = title.with_indifferent_access
      @index = title_counter - 1
      @description_id = description_id
    end

    def frame_id
      "titleFrame_#{@index}"
    end
  end
end
