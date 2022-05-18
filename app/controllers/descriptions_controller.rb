# frozen_string_literal: true

# Controller for descriptions (active record)
class DescriptionsController < ApplicationController
  def show; end

  def update
    description = Description.find(params[:id].to_i)
    DorService.update(description)
    description.destroy!

    flash[:notice] = 'Description updated.'
    redirect_to :root
  end
end
