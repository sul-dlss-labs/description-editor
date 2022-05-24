# frozen_string_literal: true

module TitleComponents
  class NestedShowComponent < ViewComponent::Base
    def initialize(title_model:)
      @title_model = title_model
    end

    def title
      @title_model
    end

    def language_name
      ISO_639.find(title.language_code)&.english_name || title.language_code
    end

    def script_name
      Iso15924.data.dig(title.script_code, 'english') || title.script_code
    end
  end
end
