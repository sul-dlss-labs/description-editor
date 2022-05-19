# frozen_string_literal: true

module Accordion
  class ItemComponent < ViewComponent::Base
    def initialize(description_id:, description_field:, show: false)
      @description_id = description_id
      @description_field = description_field
      @show = show
    end

    def header_id
      "#{@description_field}Heading"
    end

    def collapse_id
      "#{@description_field}Collapse"
    end

    def frame_id
      "#{@description_field}Frame"
    end

    def title
      @description_field.to_s.titlecase
    end

    def show_class
      @show ? ' show' : ''
    end

    def field_path
      "#{description_path(@description_id)}/#{@description_field.to_s.pluralize}"
    end
  end
end
