# frozen_string_literal: true

# Controller for the title field
class TitlesController < ApplicationController
  before_action :load_description, only: %i[index edit update new create destroy move]

  def index
    render_index
  end

  def edit
    @title_model = Model::Title.from_cocina_props(index: title_index,
                                                  cocina_title_props: @description.title[title_index])
    @title_form = TitleForm.new(@title_model)
  end

  def update
    title_model = Model::Title.from_cocina_props(index: title_index,
                                                 cocina_title_props: @description.title[title_index])
    @title_form = TitleForm.new(title_model)
    @title_form.validate(params.require(:title))
    @title_form.sync

    new_title_props = @description.title[title_index].merge(@title_form.model.to_cocina_props).compact
    cocina_title = Cocina::Models::Title.new(new_title_props)
    @description.title[title_index] = cocina_title.to_h
    @description.save!

    render_index
  end

  def new
    @title_form = TitleForm.new(Model::Title.new)
  end

  def create
    title_form = TitleForm.new(Model::Title.new)
    title_form.validate(params.require(:title))
    title_form.sync

    cocina_title = Cocina::Models::Title.new(title_form.model.to_cocina_props.compact)
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

    move_title = @description.title.delete_at(from_index)
    @description.title.insert(to_index, move_title)
    @description.save!

    render_index
  end

  private

  def load_description
    @description = Description.select(:id, :title).find(params[:description_id])
  end

  def render_index
    @title_models = @description.title.map.with_index do |title_props, index|
      Model::Title.from_cocina_props(index: index, cocina_title_props: title_props)
    end
    @titles = @description.title
    render :index
  end

  def title_index
    params[:id].to_i
  end
end
