class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.text :short_description
      t.text :long_description
      t.boolean :active

      t.timestamps
    end
  end
end
