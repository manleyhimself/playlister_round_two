class PlaylistController < ApplicationController
  enable :sessions

  get '/' do
    Playlist.create
    redirect '/playlist'
    #session[:song_votes] = {}
  end

  # get '/spotify' do
  #   @queries = Spotify_Finder.search(params[:search])
  #   session[:queries] = @queries
  #   redirect '/playlist'
  # end

  post '/playlist/add' do
    @song = Playlist[1].add_song(params[:song], request.ip)
    if @song == :user_limit_met
      redirect '/playlist/user_limit'
    elsif @song == :playlist_full
      redirect '/playlist/full'
    end
    session[:queries] = nil
    redirect '/playlist'
  end

  get '/playlist/user_limit' do
    erb :'playlist/user_limit'
  end

  get '/playlist/full' do
    erb :'playlist/playlist_full'
  end

  get '/playlist' do 
    @queries = session[:queries]
    @playlist = Playlist[1]
    if session[:current_song]
      @current_song = session[:current_song]
      @songs = @playlist.song_sort.reject{ |song| song if song == @current_song }
    else
      @songs = @playlist.song_sort
    end
    erb :'playlist/playlist'
  end

  get '/songs/:id/upvote' do
    @song = Playlist[1].songs.detect {|song| song.id == params[:id].to_i}
    @song.vote(request.ip)
    redirect '/playlist'
  end

  get '/playlist/played/:uri' do
    Playlist[1].after_play(params[:uri])
    session[:current_song] = Playlist[1].songs_in_queue.first
    redirect '/playlist'  
  end
end

# HEROKU OR RASPBERRY PI

# master page
#   -master user creates 'room' with name and password
#   -teather to spotify login
#   -master streams songs
#   -has user page functionality

# user page



# duplication!
# Spotify functionality
# AJAX
#   -search results
#   -list sorting by vote count
#   -
# Where to play the song?
#   -adding to database with after_play callback
#   -removing song from list with after_play callback
# CSS/ page design
# archive/ history page?
# server/ database