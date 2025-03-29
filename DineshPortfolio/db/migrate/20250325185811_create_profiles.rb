class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :title
      t.string :image_url
      t.text :biography

      t.timestamps
    end
  end
end
