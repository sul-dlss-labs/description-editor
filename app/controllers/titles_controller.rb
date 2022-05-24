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
    return render :edit if handle_move

    @title_model = Title.new(title_params)

    return render :edit, status: :unprocessable_entity unless @title_model.valid?

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
    return render :new if handle_move

    @title_model = Title.new(title_params)

    return render :new, status: :unprocessable_entity unless @title_model.valid?

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

  def handle_move
    return false unless params[:from_key].present? && params[:to_key].present?

    split_from_key = split_move_key(params[:from_key])
    split_to_key = split_move_key(params[:to_key])
    title_params_hash = title_params.to_unsafe_h

    # Moving top-level structured values - ["title", "structured_values_attributes", "2", "drag"]
    if split_from_key[1] == 'structured_values_attributes' && split_from_key[3] == 'drag'
      move_attributes(split_from_key[2].to_i, split_to_key[2].to_i, 'structured_values_attributes', title_params_hash)
    end
    # Moving top-level parallel titles - ["title", "parallel_titles_attributes", "2", "drag"]
    if split_from_key[1] == 'parallel_titles_attributes' && split_from_key[3] == 'drag'
      move_attributes(split_from_key[2].to_i, split_to_key[2].to_i, 'parallel_titles_attributes', title_params_hash)
    end
    # Moving nested structured values - ["title", "parallel_titles_attributes", "2", "structured_values_attributes", "1", "drag"]
    if split_from_key[1] == 'parallel_titles_attributes' && split_from_key[5] == 'drag'
      move_attributes(split_from_key[4].to_i, split_to_key[4].to_i, 'structured_values_attributes',
                      title_params_hash[:parallel_titles_attributes][split_from_key[2]])
    end

    @title_model = Title.new(title_params_hash)

    true
  end

  def move_attributes(from_index, to_index, name, params_hash)
    new_keys = params_hash[name.to_sym].keys
    new_keys.delete_at(from_index)
    new_keys.insert(to_index, from_index.to_s)
    params_hash[name.to_sym] = {}.tap do |attrs|
      new_keys.each_with_index do |index, new_index|
        attrs[new_index.to_s] = params_hash[name.to_sym][index]
      end
    end
  end

  def split_move_key(key)
    key.split(/[\[\]]+/)
  end

  def title_params
    params.require(:title).permit(:value,
                                  :primary_status,
                                  parallel_titles_attributes: [:value, :_destroy,
                                                               { structured_values_attributes: %i[value type _destroy] }],
                                  structured_values_attributes: %i[value type _destroy])
  end
end
