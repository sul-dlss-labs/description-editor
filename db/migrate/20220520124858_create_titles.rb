class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles do |t|
      t.string :value
      t.boolean :primary_status
      t.string :type
      t.string :language_code
      t.string :script_code
      t.string :transliteration_standard
      t.string :display_label
      t.string :value_at
      # Title has parallel titles
      t.belongs_to :title
    end
  end
end
