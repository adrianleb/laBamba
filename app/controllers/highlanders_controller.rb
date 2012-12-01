require 'open-uri'

class HighlandersController < ApplicationController

  def dictionary
    words = params['text'].split(/[.,!?; \t\n]/)
    dictionary = [] 
    words.each do |w|
      # TODO remove emtpy and stop words
      word = Word.find_by_name(w)
      word = Word.create(image: image(w), name: w, sound: sound(w)) unless word
      dictionary << word
    end

    render json: dictionary

  end

  def image(w)
    result = nil
=begin  
    Key:
    14ca15db980e203bfd67bc0dd8468aa5
    Secret:
    079fcb1071b4ad72
=end

    # http://www.flickr.com/services/api/explore/flickr.photos.search
    request = open("http://api.flickr.com/services/rest/?method=flickr.photos.search&privacy_filter=1&api_key=14ca15db980e203bfd67bc0dd8468aa5&text=#{CGI::escape(w)}&format=json&nojsoncallback=1")
    json = request.read
    photos = JSON.parse json
    if photos['photos'].present? && photos['photos']['photo'].present?
      photo = photos['photos']['photo'].first
      if photo
        # http://www.flickr.com/services/api/explore/flickr.photos.getSizes
        puts "zongo: " + photo['id'].to_s
        request = open("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=14ca15db980e203bfd67bc0dd8468aa5&photo_id=#{photo['id']}&format=json&nojsoncallback=1")
        json = request.read
        sizes = JSON.parse json
        last = sizes['sizes']['size'].last
        result = last['source'] if last.present?
      end
    end
    result 
  end

  def sound(w)
    # sudo apt-get install gespeaker xsel
    # espeak -v en "Hello I am marcel" -w ~/lala.wav 
    file_path = Rails.root.join("public", "wav", "#{w}.wav")
    print 'file_path: ' + file_path.to_s
    result = `espeak -v en "#{w}" -w #{file_path}`
    puts 'result: ' + result.to_s
    File.join('http://localhost:3000/', "wav", "#{w}.wav")
  end


end
