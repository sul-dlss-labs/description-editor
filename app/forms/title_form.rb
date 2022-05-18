# frozen_string_literal: true

require 'disposable/twin/property/hash'

class TitleForm < Reform::Form
  property :description_id
  property :index

  property :title do
    include Disposable::Twin::Property::Struct
    property :value
  end

  unnest :value, from: :title
  # collection :title do
  #   include Disposable::Twin::Property::Struct
  #   property :value
  # end

  def persisted?
    model.present?
  end

  def save_model
    new_description_title = model.description.title.dup
    if model.index == model.description.title.size
      new_description_title << model.title
    else
      # By merging, not throwing away any existing values that are not on the form.
      new_description_title[model.index].merge!(model.title)
    end
    model.description.title = new_description_title.map { |title| Cocina::Models::Title.new(title).to_h }
    model.description.save!
  end
end
