# frozen_string_literal: true

module Title
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title_model

    def initialize(description_id:, title_model:, title_model_counter:)
      @title_model = title_model
      @index = title_model_counter - 1
      @description_id = description_id
    end

    def frame_id
      "titleFrame_#{@index}"
    end
  end
end
