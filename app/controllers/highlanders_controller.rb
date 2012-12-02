require 'open-uri'
require 'pusher'

Pusher.app_id = '32812'
Pusher.key = '10cae45fefc4b7d45273'
Pusher.secret = '48cafd8feb9bec428fa4'


class HighlandersController < ApplicationController

  def dictionary
    words = params['text'].split(/[.,!?; \t\n]/)
    dictionary = [] 
    Pusher['word_progress'].trigger('total_words', words.length )
    words.each do |w|
      # TODO remove emtpy and stop words

      word = Word.where("name = '#{w}'").order('RAND()').limit(1) if (Random.new().rand() < 0.8)
      word = word[0] if word.present?
      s = sound(w)
      word = Word.create(image: image(w), name: w, sound_url: s[:url], sound_duration: s[:duration]) if word.blank? or word == []
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
    request = open("http://api.flickr.com/services/rest/?method=flickr.photos.search&privacy_filter=1&api_key=14ca15db980e203bfd67bc0dd8468aa5&text=#{CGI::escape(w)}&format=json&nojsoncallback=1&safe_search=3&content_type=4")
    json = request.read
    photos = JSON.parse json
    if photos['photos'].present? && photos['photos']['photo'].present?
      photo = photos['photos']['photo'].first
      if photo
        # http://www.flickr.com/services/api/explore/flickr.photos.getSizes
        puts "zongo: " + photo['id'].to_s

        Pusher['word_progress'].trigger('update', 1)

        request = open("http://api.flickr.com/services/rest/?method=flickr.photos.getSizes&api_key=14ca15db980e203bfd67bc0dd8468aa5&photo_id=#{photo['id']}&format=json&nojsoncallback=1")
        json = request.read
        sizes = JSON.parse json
        last = sizes['sizes']['size'][(sizes['sizes']['size'].length/2).ceil]
        result = last['source'] if last.present?
      end
    end
    result 
  end

  def sound(w)
    # sudo apt-get install gespeaker xsel
    # espeak -v en "Hello I am marcel" -w ~/lala.wav 
    file_path = Rails.root.join("public", "wav", "#{w}.wav")
    result = `espeak -v en "#{w}" -w #{file_path}`

    # sox public/wav/marcel.wav -n stat 2>&1 | grep Length | cut -d : -f 2
    duration = `sox #{file_path} -n stat 2>&1 | grep Length | cut -d : -f 2`.strip

    {url: File.join('http://localhost:3000/', "wav", "#{w}.wav"), duration: duration}
  end


end
