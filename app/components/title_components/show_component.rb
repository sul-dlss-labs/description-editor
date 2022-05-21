# frozen_string_literal: true

module TitleComponents
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title_model

    def initialize(description_id:, title_model:, title_model_counter: nil, index: nil)
      @title_model = title_model
      @index = index&.to_i || (title_model_counter - 1)
      @description_id = description_id
    end

    def frame_id
      "titleFrame_#{@index}"
    end

    def title
      @title_model
    end
  end
end
