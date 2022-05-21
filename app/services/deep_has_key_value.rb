# frozen_string_literal: true

# Recursively check enumerable for key/value
class DeepHasKeyValue
  def self.has?(enumerable, key, value)
    new(enumerable, key, value).has?
  end

  def initialize(enumerable, key, value)
    @enumerable = enumerable
    @key = key
    @value = value
  end

  def has?
    return true if enumerable.is_a?(Hash) && enumerable[key] == value

    if enumerable.is_a?(Enumerable)
      return enumerable.any? do |check_enumerable|
               self.class.has?(check_enumerable, key, value)
             end
    end

    false
  end

  private

  attr_reader :enumerable, :key, :value
end
