# frozen_string_literal: true

# Controller for the title field
class TitlesController < ApplicationController
  def index
    @titles = Description.select(:title).find(params[:description_id]).title
  end
end
