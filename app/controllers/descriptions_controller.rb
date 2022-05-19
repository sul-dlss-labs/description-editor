# frozen_string_literal: true

# Controller for descriptions (active record)
class DescriptionsController < ApplicationController
  def show
    @druid = Description.select(:external_identifier).find(params[:id]).external_identifier
  end

  def update
    description = Description.find(params[:id])
    DorService.update(description)
    description.destroy!

    flash[:notice] = 'Description updated.'
    redirect_to :root
  end
end
