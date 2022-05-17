# frozen_string_literal: true

# Controller for home actions
class HomeController < ApplicationController
  def index; end

  def load
    # TODO: Normalize druid: prefix
    description = Description.find_by(external_identifier: [params[:id]])
    description ||= DorService.load(params[:id])
    # TODO: Handle exceptions
    # TODO: Handle resume vs. reload
    redirect_to description
  end
end
