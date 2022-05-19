module Model
  class Title
    include ActiveModel::API

    attr_accessor :value, :primary_status

    validates :primary_status, inclusion: [true, false]

    def to_cocina_props
      {
        value: value,
        status: primary_status ? 'primary' : nil
      }
    end

    def self.from_cocina_props(title_props)
      from_cocina(Cocina::Models::Title.new(title_props))
    end

    def self.from_cocina(cocina_title)
      new({
            value: cocina_title.value,
            primary_status: cocina_title.status == 'primary'
          })
    end
  end
end