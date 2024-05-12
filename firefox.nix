{pkgs, ...}: with pkgs;
runCommand "my-firefox" {
  buildInputs = [ makeWrapper ];
} ''
  mkdir $out
  ln -s ${firefox}/* $out
  rm $out/bin
  mkdir $out/bin
  ln -s ${firefox}/bin/firefox $out/bin
  # rm $out/bin/
  makeWrapper ${firefox}/bin/firefox $out/bin/my-firefox \
    --set HOME "/opt/ff"
''
