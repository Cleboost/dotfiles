# Adwaita for UI/places/mimes; WhiteSur application icons only (symlinked at build time).
{ pkgs }:

pkgs.runCommand "cleboost-icon-theme" { } ''
  ws=${pkgs.whitesur-icon-theme}/share/icons/WhiteSur-dark
  outIcons=$out/share/icons/cleboost-icons
  mkdir -p "$outIcons"

  for entry in "$ws"/apps*; do
    ln -s "$entry" "$outIcons/$(basename "$entry")"
  done

  cat > "$outIcons/index.theme" <<'EOF'
[Icon Theme]
Name=cleboost-icons
Comment=Adwaita UI; WhiteSur desktop application icons only
Inherits=Adwaita,hicolor
Directories=apps/16,apps/22,apps/32,apps/scalable,apps/symbolic
ScaledDirectories=apps@2x/16,apps@2x/22,apps@2x/32,apps@2x/scalable,apps@2x/symbolic

[apps/16]
Size=16
Context=Applications
Type=Fixed

[apps/22]
Size=22
Context=Applications
Type=Fixed

[apps/32]
Size=32
Context=Applications
Type=Fixed

[apps/scalable]
Size=64
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[apps/symbolic]
Size=16
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[apps@2x/22]
Size=22
Scale=2
Context=Applications
Type=Fixed

[apps@2x/32]
Size=32
Scale=2
Context=Applications
Type=Fixed

[apps@2x/scalable]
Size=64
Scale=2
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[apps@2x/symbolic]
Size=16
Scale=2
Context=Applications
MinSize=16
MaxSize=512
Type=Scalable

[apps@2x/16]
Size=16
Scale=2
Context=Applications
Type=Fixed
EOF
''
