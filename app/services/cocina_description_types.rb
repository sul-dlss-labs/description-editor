# frozen_string_literal: true

# Provides valid values for Cocina description types
class CocinaDescriptionTypes
  def self.types_for(type_signature)
    new.types_for(type_signature)
  end

  def types_for(type_signature)
    types.fetch(type_signature)
  end

  def types
    # Class var to minimize loading from disk.
    @@types ||= {}.tap do |types|
      types_yaml.map do |type_signature, type_objs|
        types[type_signature] = type_objs.map { |type_obj| type_obj['value'].downcase }
      end
    end
  end

  private

  def types_yaml
    gem_path = Gem.loaded_specs['cocina-models'].full_gem_path
    YAML.load_file("#{gem_path}/description_types.yml")
  end
end
