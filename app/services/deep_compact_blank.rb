# frozen_string_literal: true

# Recursively compact enumerables of blank values
class DeepCompactBlank
  def self.compact(enumerable)
    new(enumerable).compact
  end

  def initialize(enumerable)
    @enumerable = enumerable
  end

  def compact
    return enumerable unless enumerable.respond_to?(:compact_blank)

    enumerable
      .compact_blank
      .public_send(enumerable.is_a?(Hash) ? :transform_values : :map) { |value| self.class.compact(value) }
  end

  private

  attr_reader :enumerable
end
