# frozen_string_literal: true

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  fragment = Nokogiri::HTML.fragment(html_tag)
  field = fragment.at('input,select,textarea')

  model = instance.object
  error_message = model.errors.full_messages.join(', ')

  html = if field
           field[:class] = [field[:class], 'is-invalid'].compact.join(' ')
           error_id = "#{field[:id]}InvalidFeedback"
           field['aria-describedby'] = [field['aria-describedby'], error_id].compact.join(' ')
           html = <<-HTML
              #{fragment}
              <p class="invalid-feedback" id="#{error_id}">#{error_message}</p>
           HTML
           html
         else
           html_tag
         end

  html.html_safe
end
