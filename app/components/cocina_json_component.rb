# frozen_string_literal: true

class CocinaJsonComponent < ViewComponent::Base
  def initialize(props:, description_field:)
    @props = props
    @description_field = description_field
  end

  def json
    # This makes an empty array prettier then pretty_generate
    return '[]' if @props == []

    JSON.pretty_generate(DeepCompactBlank.compact(@props))
  end

  def header
    "#{@description_field.to_s.titlecase} Cocina JSON"
  end
end
