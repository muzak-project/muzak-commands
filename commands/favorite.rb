module Muzak
  module Cmd
    def favorite
      playlist_add_current "favorites"

      build_response
    end

    def unfavorite
      playlist_del_current "favorites"

      build_response
    end
  end
end
