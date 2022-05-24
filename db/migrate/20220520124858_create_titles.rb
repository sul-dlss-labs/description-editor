class CreateTitles < ActiveRecord::Migration[7.0]
  def change
    create_table :titles do |t|
      t.string :value
      t.boolean :primary_status
      t.string :type
      # Title has parallel titles
      t.belongs_to :title
    end
  end
end
