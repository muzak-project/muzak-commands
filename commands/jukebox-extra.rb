module Muzak
  module Cmd
    def jukebox_artist(artist)
      songs = index.songs_by(artist).shuffle

      clear_queue unless songs.empty?

      songs.each do |song|
        player.enqueue_song song
      end

      build_response
    end
  end
end
