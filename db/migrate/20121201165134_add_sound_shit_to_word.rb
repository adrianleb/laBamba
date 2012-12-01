class AddSoundShitToWord < ActiveRecord::Migration
  def change
    add_column :words, :sound_url, :string
    add_column :words, :sound_duration, :string
    remove_column :words, :sound
  end
end
