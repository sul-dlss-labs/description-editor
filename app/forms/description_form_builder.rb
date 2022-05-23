# frozen_string_literal: true

class DescriptionFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, label:, **options, &block)
    options[:class] = merge_class(options, 'form-control')
    @template.content_tag(:div, class: 'form-floating') do
      super(attribute, options, &block) + label(label)
    end
  end

  def check_box(attribute, label:, **options, &block)
    options[:class] = merge_class(options, 'form-check-input')
    @template.content_tag(:div, class: 'form-check') do
      super(attribute, options, &block) + label(label, { class: 'form-check-label' })
    end
  end

  def button(attribute, **options, &block)
    options[:class] = merge_class(options, 'btn', 'btn-outline-primary btn-sm')
    super(attribute, options, &block)
  end

  def submit(attribute, **options, &block)
    options[:class] = merge_class(options, 'btn', 'btn-outline-primary btn-sm')
    super(attribute, options, &block)
  end

  def delete_button(attribute, **options, &block)
    options[:value] = true
    options[:name] = field_name(:_destroy, index: nil)
    button(attribute, **options, &block)
  end

  def add_button(attribute, **options, &block)
    options[:value] = true
    options[:name] = field_name(attribute, index: nil)
    button(attribute, **options, &block)
  end

  def select(attribute, choices = nil, label:, options: {}, html_options: {}, &block)
    html_options[:class] = merge_class(options, 'form-select')
    html_options['aria-label'] = label
    options[:include_blank] = true

    @template.content_tag(:div, class: 'form-floating') do
      super(attribute, choices, options, html_options, &block) + label(label)
    end
  end

  def errors(key: :base)
    if object.errors.include?(key)
      @template.content_tag(:div, class: 'alert alert-danger') do
        object.errors[key].join(', ')
      end
    end
  end

  private

  def merge_class(options, *classes)
    new_classes = classes
    new_classes.append(options[:class].split) if options.key?(:class)
    new_classes.uniq.join(' ')
  end
end
