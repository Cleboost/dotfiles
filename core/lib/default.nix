{ lib }:

rec {
  # Recursively scan a directory for NixOS / Home Manager modules.
  # - Regular `.nix` files (except `default.nix`) are imported.
  # - Subdirectories containing `default.nix` are imported as a single module
  #   (so internal helper `.nix` files inside them are not auto-imported).
  # - Other subdirectories are traversed recursively.
  scanModules =
    dir:
    let
      entries = builtins.readDir dir;
      processEntry =
        name: type:
        let
          path = dir + "/${name}";
        in
        if lib.hasPrefix "_" name then
          [ ]
        else if type == "regular" then
          if lib.hasSuffix ".nix" name && name != "default.nix" then [ path ] else [ ]
        else if type == "directory" then
          if builtins.pathExists (path + "/module.nix") then
            [ (path + "/module.nix") ]
          else if builtins.pathExists (path + "/default.nix") then
            [ path ]
          else
            scanModules path
        else
          [ ];
    in
    lib.concatLists (lib.mapAttrsToList processEntry entries);
}
