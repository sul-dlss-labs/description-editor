# frozen_string_literal: true

# Controller for the title field
class TitlesController < ApplicationController
  before_action :load_description, only: %i[index edit update new create destroy move]
  before_action :load_form, only: %i[edit update]

  TitleStruct = Struct.new('TitleStruct', :description_id, :index, :title, :description)

  def index
    @titles = @description.title
  end

  def edit; end

  def update
    @form.validate(params.require(:title))
    @form.save

    @titles = @description.title
    render :index
  end

  def new
    title_struct = TitleStruct.new(params[:description_id], @description.title.size, {}, @description)
    @form = TitleForm.new(title_struct)
  end

  def create
    title_struct = TitleStruct.new(params[:description_id], @description.title.size, {}, @description)
    @form = TitleForm.new(title_struct)

    @form.validate(params.require(:title))
    @form.save

    @titles = @description.title
    render :index
  end

  def destroy
    @description.title.delete_at(params[:id].to_i)
    @description.save!

    @titles = @description.title
    render :index
  end

  def move
    from_index = params[:from_index].to_i
    to_index = params[:id].to_i

    Rails.logger.info("Move #{from_index} to #{to_index}")

    move_title = @description.title.delete_at(from_index)
    @description.title.insert(to_index, move_title)
    @description.save!

    @titles = @description.title
    render :index
  end

  private

  def load_description
    @description = Description.select(:id, :title).find(params[:description_id])
  end

  def load_form
    title_struct = TitleStruct.new(params[:description_id], params[:id].to_i, @description.title[params[:id].to_i],
                                   @description)
    @form = TitleForm.new(title_struct)
  end
end
