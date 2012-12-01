class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :image
      t.string :name
      t.string :sound

      t.timestamps
    end
  end
end
