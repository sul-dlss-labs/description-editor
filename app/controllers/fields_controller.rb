# frozen_string_literal: true

# Controller for unimplemented field
class FieldsController < ApplicationController
  def show
    @field = singularize(params[:field])
    @values = Description.select(@field.to_sym).find(params[:description_id]).public_send(@field.to_sym)
  end

  private

  def singularize(field)
    field.singularize.tap do |new_field|
      new_field.gsub!(/atum$/, 'ata')
    end
  end
end
