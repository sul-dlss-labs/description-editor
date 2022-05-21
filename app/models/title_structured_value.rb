# frozen_string_literal: true

class TitleStructuredValue < ApplicationRecord
  # Since this has a "type" field:
  self.inheritance_column = :_type_disabled

  belongs_to :title

  def to_cocina_props
    {
      value: value.presence,
      type: type.presence
    }.compact
  end

  def self.from_cocina(cocina_structured_value)
    params = {
      value: cocina_structured_value.value,
      type: cocina_structured_value.type
    }
    new(params)
  end
end
