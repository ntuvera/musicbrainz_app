require 'bundler'
Bundler.require

get '/' do
  erb :index
end

get '/result' do
  @artist = Musicbrainz.find(params[:artist_name])
  @artist_name = params[:artist_name]

  # binding.pry

  if @artist[0].class == Hash
    @result_name = @artist[0]['name']
    @result_country = @artist[0]['country']
    @result_begin_date = @artist[0]['life_span']['being']

    if @artist[0]['tag_list']
      @result_disambiguation = @artist[0]['tag_list']['tag']
      else
      @result_disambiguation = [{"name" => "Undefined"}]
    end

    if @artist[0]['alias_list']
       @result_alias = @artist[0]['alias_list']['alias']['__content__']
      else
      @result_alias = "Undefined"
    end


    erb :result
    else
    erb :error
  end
end

module Musicbrainz
  def self.find(artist_name)
    # make call to api
    artist_name = artist_name.gsub(' ', '%20')
    url = "http://musicbrainz.org/ws/2/artist?query=" + artist_name
    response = HTTParty.get(url)
    return response['metadata']['artist_list']['artist']
    # data = response['metadata']['artist_list']['artist']
    # artist name in result = artist[0]['name']
    # country result = artist[0]['country']
    # begin_date = artist[0]['life_span']['begin']
    # disambig = artist[1]['disambiguation']
  end
end


artists = Musicbrainz.find('prince')
