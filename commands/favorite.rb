module Muzak
  module Cmd
    def favorite
      playlist_add_current "favorites"
    end

    def unfavorite
      playlist_del_current "favorites"
    end
  end
end
