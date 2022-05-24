# frozen_string_literal: true

module Drag
  class TargetComponent < ViewComponent::Base
    def initialize(title_index:, key: nil)
      @key = key
      @title_index = title_index
    end
  end
end
