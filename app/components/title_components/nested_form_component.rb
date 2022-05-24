# frozen_string_literal: true

module TitleComponents
  class NestedFormComponent < ViewComponent::Base
    def initialize(form:)
      @form = form
    end

    def structured_type_choices
      CocinaDescriptionTypes.types_for('title.structuredValue')
    end

    def type_choices
      CocinaDescriptionTypes.types_for('title')
    end

    def language_choices
      @@language_choices ||= ISO_639::ISO_639_2.map do |language|
        [language.english_name, language.alpha3_bibliographic]
      end
    end

    def script_choices
      @@script_choices ||= Iso15924.data.map { |code, entry| [entry['english'], code] }
    end
  end
end
