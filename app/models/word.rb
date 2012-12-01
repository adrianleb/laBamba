class Word < ActiveRecord::Base
  attr_accessible :image, :name, :sound_url, :sound_duration 
end
