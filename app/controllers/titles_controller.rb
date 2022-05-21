# frozen_string_literal: true

# Controller for the title field
class TitlesController < ApplicationController
  before_action :load_description

  def index
    render_index
  end

  def show
    @title_model = Title.from_cocina_props(@description.title[title_index])
  end

  def edit
    @title_model = Title.from_cocina_props(@description.title[title_index])
  end

  def update
    return render :edit if handle_form_changes

    @title_model = Title.new(title_params)
    @description.title[title_index] = @title_model.to_cocina_props
    @description.save!

    respond_to do |format|
      format.turbo_stream
    end
  end

  def new
    @title_model = Title.new
  end

  def create
    return render :new if handle_form_changes

    @title_model = Title.new(title_params)
    @description.title << @title_model.to_cocina_props
    @description.save!

    @index = @description.title.size - 1

    respond_to do |format|
      format.turbo_stream
    end
  end

  def destroy
    @description.title.delete_at(params[:id].to_i)
    @description.save!

    respond_to do |format|
      format.turbo_stream
    end
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
    @title_models = @description.title.map do |title_props|
      Title.from_cocina_props(title_props)
    end
    # Using forms since they are easier to work with then models.
    @title_forms = @description.title.map.with_index do |title_props, index|
      TitleForm.new(Model::Title.from_cocina_props(index: index, cocina_title_props: title_props))
    end

    render :index
  end

  def title_index
    params[:id].to_i
  end

  def handle_form_changes
    params_hash = params.to_unsafe_h
    # Clicked a delete button
    if DeepHasKeyValue.has?(params_hash, :_destroy, 'true')
      @title_model = Title.new(title_params)
      return true
    end

    # Clicked the add structured title button.
    # This can be nested.
    if DeepHasKeyValue.has?(params_hash, :add_structured_title, 'true')
      @title_model = Title.new(title_params)
      @title_model.structured_values << TitleStructuredValue.new if params[:title][:add_structured_title] == 'true'
      Hash(params_hash[:title][:parallel_titles_attributes]).values.each_with_index do |parallel_title_params, index|
        next unless parallel_title_params[:add_structured_title] == 'true'

        @title_model.parallel_titles << Title.new unless @title_model.parallel_titles[index]
        @title_model.parallel_titles[index].structured_values << TitleStructuredValue.new
      end
      return true
    end

    # Clicked the add parallel title button.
    # This can only be at the top level.
    if params[:title][:add_parallel_title] == 'true'
      @title_model = Title.new(title_params)
      @title_model.parallel_titles << Title.new

      return true
    end
    false
  end

  def title_params
    params.require(:title).permit(:value,
                                  :primary_status,
                                  parallel_titles_attributes: [:value, :_destroy,
                                                               { structured_values_attributes: %i[value type _destroy] }],
                                  structured_values_attributes: %i[value type _destroy])
  end
end
