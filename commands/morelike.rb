module Muzak
  module Cmd
    def more_by_artist
      np = player.now_playing

      return unless np

      # obvious problem: we're comparing ID3 artist to filesystem artist
      songs = index.songs_by(np.artist).dup

      # let's not add the currently playing song to the queue
      songs.delete(np)

      clear_queue
      songs.each do |song|
        player.enqueue_song song
      end

      build_response
    end

    def more_from_album
      np = player.now_playing

      return unless np

      # obvious problem: we're comparing ID3 album to filesystem album
      album = index.albums[np.album]

      return unless album

      # let's not add the currently playing song to the queue
      songs = album.songs.dup
      songs.delete(np)

      clear_queue
      songs.each do |song|
        player.enqueue_song song
      end

      build_response
    end
  end
end
