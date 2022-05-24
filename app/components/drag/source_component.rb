# frozen_string_literal: true

module Drag
  class SourceComponent < ViewComponent::Base
    def initialize(title_index:, key: nil)
      @key = key
      @title_index = title_index
    end

    def drag_key
      "titles[#{@title_index}]#{@key}"
    end
  end
end
