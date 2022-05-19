# frozen_string_literal: true

# Controller for the title field
class TitlesController < ApplicationController
  before_action :load_description, only: %i[index edit update new create destroy move]
  # after_action :prepare_index, only: [:index]
  # before_action :load_form, only: %i[edit update]

  # TitleStruct = Struct.new('TitleStruct', :description_id, :index, :title, :description)

  def index
    # prepare_index
    # @title_models = @description.title.map {|title_props| Model::Title.from_cocina_props(title_props)}
    # @titles = @description.title
    render_index
  end

  def edit
    @title_model = Model::Title.from_cocina_props(@description.title[params[:id].to_i])
  end

  def update
    title_model = Model::Title.new(update_params)
    # TODO: title.valid?

    new_title_props = @description.title[params[:id].to_i].merge(title_model.to_cocina_props).compact
    cocina_title = Cocina::Models::Title.new(new_title_props)
    @description.title[params[:id].to_i] = cocina_title.to_h
    @description.save!

    render_index
  end

  def new
    @title_model = Model::Title.new
  end

  def create
    title_model = Model::Title.new(update_params)
    # TODO: title.valid?

    cocina_title = Cocina::Models::Title.new(title_model.to_cocina_props)
    @description.title << cocina_title.to_h
    @description.save!

    render_index
  end

  def destroy
    @description.title.delete_at(params[:id].to_i)
    @description.save!

    render_index
  end

  def move
    from_index = params[:from_index].to_i
    to_index = params[:id].to_i

    Rails.logger.info("Move #{from_index} to #{to_index}")

    move_title = @description.title.delete_at(from_index)
    @description.title.insert(to_index, move_title)
    @description.save!

    render_index
  end

  private

  def load_description
    @description = Description.select(:id, :title).find(params[:description_id])
  end

  # def load_form
  #   title_struct = TitleStruct.new(params[:description_id], params[:id].to_i, @description.title[params[:id].to_i],
  #                                  @description)
  #   @form = TitleForm.new(title_struct)
  # end

  def update_params
    params.require(:model_title).permit(:value, :primary_status)
  end

  def render_index
    @title_models = @description.title.map {|title_props| Model::Title.from_cocina_props(title_props)}
    @titles = @description.title
    render :index
  end  
end
