# frozen_string_literal: true

# Controller for home actions
class HomeController < ApplicationController
  def index; end

  def load
    @description = Description.find_by(external_identifier: druid_param)
    if @description
      if params[:discard]
        @description.destroy!
      else
        return render :confirm
      end
    end

    @description = DorService.load(druid_param)
    # TODO: Handle exceptions
    redirect_to @description
  end

  def druid_param
    params[:id].starts_with?('druid:') ? params[:id] : "druid:#{params[:id]}"
  end
end
