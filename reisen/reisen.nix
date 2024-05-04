{ pkgs
, ...
}: with pkgs;
  writeShellScriptBin "reisen" (builtins.readFile ./reisen.sh) 
