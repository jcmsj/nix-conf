{ lib, pkgs, ... }:

{
  pkgs.user-dirs = pkgs.writeTextFile {
          name = "user-dirs.defaults";
          text = ''
            XDG_DOCUMENTS_DIR=/media/sorairo/Docs
            XDG_MUSIC_DIR=media/sorairo/music
            XDG_PICTURES_DIR=media/sorairo/Pics
            XDG_VIDEOS_DIR=media/sorairo/videos
          '';
          destination = "/etc/xdg/user-dirs.defaults";
  };
}
