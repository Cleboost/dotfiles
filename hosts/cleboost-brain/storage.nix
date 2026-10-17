# SATA SSD (jeux) + HDD (fichiers). Labels set at format: cleboost-games / cleboost-data.
{ ... }:

{
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/29316cb0-75f7-47f6-836e-7c5672923bd8";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/be155c38-ca6e-4314-bbf3-713900b306be";
    fsType = "ext4";
    options = [ "defaults" "noatime" ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/games/SteamLibrary 0755 cleboost users -"
    "d /mnt/data/Downloads 0755 cleboost users -"
    "d /mnt/data/Media 0755 cleboost users -"
    "d /mnt/data/Backup 0755 cleboost users -"
  ];
}
