# frozen_string_literal: true

class Title < ApplicationRecord
  has_many :structured_values, class_name: 'TitleStructuredValue'
  accepts_nested_attributes_for :structured_values, reject_if: :all_blank, allow_destroy: true

  has_many :parallel_titles, class_name: 'Title'
  accepts_nested_attributes_for :parallel_titles, reject_if: :all_blank, allow_destroy: true

  def to_cocina_props
    props = {
      value: value.presence,
      status: primary_status ? 'primary' : nil,
      structuredValue: structured_values.map(&:to_cocina_props),
      parallelValue: parallel_titles.map(&:to_cocina_props)
    }.compact
    Cocina::Models::Title.new(props).to_h
  end

  def self.from_cocina_props(props)
    from_cocina(Cocina::Models::Title.new(props))
  end

  def self.from_cocina(cocina_title)
    params = {
      value: cocina_title.value,
      primary_status: cocina_title.status == 'primary',
      structured_values: cocina_title.structuredValue.map do |cocina_structured_value|
                           TitleStructuredValue.from_cocina(cocina_structured_value)
                         end,
      parallel_titles: cocina_title.parallelValue.map do |cocina_parallel_value|
                         Title.from_cocina(cocina_parallel_value)
                       end
    }
    new(params)
  end
end
