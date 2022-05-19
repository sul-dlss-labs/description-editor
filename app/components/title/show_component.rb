# frozen_string_literal: true

module Title
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title_model

    def initialize(description_id:, title_model:)
      @title_model = title_model
      # @index = title_model_counter - 1
      @description_id = description_id
    end

    def frame_id
      "titleFrame_#{@title_model.index}"
    end

    def index
      @title_model.index
    end

    def value
      @title_model.props[:value]
    end

    def primary_status?
      @title_model.props[:primary_status]
    end
  end
end
