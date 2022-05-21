class CreateTitleStructuredValues < ActiveRecord::Migration[7.0]
  def change
    create_table :title_structured_values do |t|
      t.string :value
      t.string :type
      t.belongs_to :title
    end
  end
end
