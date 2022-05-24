# frozen_string_literal: true

class Title < ApplicationRecord
  # Since this has a "type" field:
  self.inheritance_column = :_type_disabled

  has_many :structured_values, class_name: 'TitleStructuredValue'
  accepts_nested_attributes_for :structured_values, reject_if: :all_blank, allow_destroy: true

  has_many :parallel_titles, class_name: 'Title'
  accepts_nested_attributes_for :parallel_titles, reject_if: :all_blank, allow_destroy: true

  validates :value_at, format: { with: URI::DEFAULT_PARSER.regexp[:ABS_URI], message: 'must be a URL' }

  validate :only_one_type_of_value

  def only_one_type_of_value
    present_values = [value, structured_values, parallel_titles].select(&:present?)
    if present_values.size > 1
      errors.add(:base, "can't have multiple types of values (value, structured values, or parallel titles)")
    end
  end

  def to_cocina_props
    props = {
      value: value.presence,
      status: primary_status ? 'primary' : nil,
      type: type.presence,
      displayLabel: display_label.presence,
      valueAt: value_at.presence,
      structuredValue: structured_values.map(&:to_cocina_props),
      parallelValue: parallel_titles.map(&:to_cocina_props)
    }.tap do |props|
      props[:valueLanguage] = { code: language_code, source: { code: 'iso639-2b' } } if language_code.present?
      if script_code.present?
        props[:valueLanguage] ||= {}
        props[:valueLanguage][:valueScript] = { code: script_code, source: { code: 'iso15924' } }
      end
      props[:standard] = { value: transliteration_standard } if transliteration_standard.present?
    end.compact
    Cocina::Models::Title.new(props).to_h
  end

  def self.from_cocina_props(props)
    from_cocina(Cocina::Models::Title.new(props))
  end

  def self.from_cocina(cocina_title)
    params = {
      value: cocina_title.value,
      display_label: cocina_title.displayLabel,
      value_at: cocina_title.valueAt,
      transliteration_standard: cocina_title&.standard&.value,
      primary_status: cocina_title.status == 'primary',
      type: cocina_title.type,
      structured_values: cocina_title.structuredValue.map do |cocina_structured_value|
                           TitleStructuredValue.from_cocina(cocina_structured_value)
                         end,
      parallel_titles: cocina_title.parallelValue.map do |cocina_parallel_value|
                         Title.from_cocina(cocina_parallel_value)
                       end
    }.tap do |params|
      if cocina_title.valueLanguage&.source&.code == 'iso639-2b'
        params[:language_code] =
          cocina_title.valueLanguage.code
      end
      if cocina_title.valueLanguage&.valueScript&.source&.code == 'iso15924'
        params[:script_code] =
          cocina_title.valueLanguage.valueScript.code
      end
    end
    new(params)
  end
end
