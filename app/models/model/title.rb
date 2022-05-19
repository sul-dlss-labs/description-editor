# frozen_string_literal: true

module Model
  class Title
    def initialize(index: nil, props: {})
      @index = index
      # Calling this prop_hash instead of props due to rails form naming gotchas
      @prop_hash = props
    end

    # include ActiveModel::API

    attr_accessor :index, :prop_hash
    # attr_reader :props
    # Aliasing due to rails form naming gotchas
    alias props prop_hash

    # def props=(props)
    #   @props = props.with_indifferent_access
    # end

    alias props= prop_hash=
    # validates :primary_status, inclusion: [true, false]

    def to_cocina_props
      indifferent_props = props.with_indifferent_access
      {
        value: indifferent_props[:value],
        status: indifferent_props[:primary_status] ? 'primary' : nil
      }.with_indifferent_access
    end

    def persisted?
      index.present?
    end

    def self.from_cocina_props(index:, cocina_title_props:)
      from_cocina(index: index, cocina_title: Cocina::Models::Title.new(cocina_title_props))
    end

    def self.from_cocina(index:, cocina_title:)
      props = {
        value: cocina_title.value,
        primary_status: cocina_title.status == 'primary'
      }
      new(index: index, props: props)
    end
  end
end
