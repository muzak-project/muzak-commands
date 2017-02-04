module Muzak
  module Cmd
    def song_pattern(pattern)
      songs = index.songs.select { |s| Glob[pattern] =~ s.title }

      songs.each { |song| player.enqueue_song song }

      build_response data: {
        songs: songs.map(&:title)
      }
    end

    def album_pattern(pattern)
      # nasty.
      albums = index.albums.select do |an, _|
        Glob[pattern] =~ an
      end.map { |e| e[1] }

      songs = albums.map(&:songs).flatten

      songs.each { |song| player.enqueue_song song }

      build_response data: {
        songs: songs.map(&:title)
      }
    end

    def artist_pattern(pattern)
      artists = index.artists.grep(Glob[pattern])

      songs = artists.map { |artist| index.songs_by(artist) }.flatten

      songs.each { |song| player.enqueue_song song }

      build_response data: {
        songs: songs.map(&:title)
      }
    end
  end

  class Glob
    def self.[](pattern)
      self.compile pattern
    end

    # cribbed from https://karottenreibe.github.io/2009/12/03/inside-the-joker/
    # i'll make this more ruby-like eventually
    def self.compile(pattern)
      ptr = 0
      compiled = '^'
      while ptr < pattern.length
          snip = pattern[ptr..ptr]
          case snip
          when '\\'
              lookahead = pattern[ptr+1..ptr+1]
              case snip
              when '\\\\', '\\?', '\\*'
                  compiled << snip << lookahead
              else
                  compiled << Regexp.quote(lookahead)
              end
              ptr += 1
          when '?' then compiled << '.'
          when '*' then compiled << '.*'
          else          compiled << Regexp.quote(snip)
          end
          ptr += 1
      end
      compiled << '$'

      Regexp.new(compiled)
    end
  end
end
