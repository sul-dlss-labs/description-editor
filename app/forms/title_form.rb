# frozen_string_literal: true

require 'disposable/twin/property/struct'
require 'disposable/twin/coercion'

class TitleForm < Reform::Form
  feature Coercion

  property :index

  # Using prop_hash instead of props due to form naming gotcha.
  property :prop_hash do
    include Disposable::Twin::Property::Struct
    property :value
    property :primary_status, type: Disposable::Twin::Coercion::Types::Params::Bool
    collection :structured_values do
      include Disposable::Twin::Property::Struct
      property :value
      property :type
    end
  end
end
