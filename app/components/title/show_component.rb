# frozen_string_literal: true

module Title
  class ShowComponent < ViewComponent::Base
    with_collection_parameter :title_form

    def initialize(description_id:, title_form:)
      @title_form = title_form
      # @index = title_model_counter - 1
      @description_id = description_id
    end

    def frame_id
      "titleFrame_#{@title_form.index}"
    end

    def index
      @title_form.index
    end

    def title
      @title_form.prop_hash
    end
  end
end
