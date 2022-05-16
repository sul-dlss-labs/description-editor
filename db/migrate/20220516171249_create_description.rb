class CreateDescription < ActiveRecord::Migration[7.0]
  def change
    create_table :descriptions do |t|
      t.string :external_identifier, null: false
      t.jsonb :title, null: false
      t.jsonb :contributor
      t.jsonb :event
      t.jsonb :form
      t.jsonb :geographic
      t.jsonb :language
      t.jsonb :note
      t.jsonb :identifier
      t.jsonb :subject
      t.jsonb :access
      t.jsonb :marcEncodingData
      t.jsonb :adminMetadata
      t.string :valueAt
      t.string :purl

      t.timestamps

      t.index :external_identifier, unique: true
    end
  end
end
