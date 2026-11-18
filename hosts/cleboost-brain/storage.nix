# SATA SSD (games) + HDD (data). Labels set at format: cleboost-games / cleboost-data.
_:

{
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/29316cb0-75f7-47f6-836e-7c5672923bd8";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/be155c38-ca6e-4314-bbf3-713900b306be";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  systemd.tmpfiles.rules = [
    # ext4 root = root after mkfs; z = owner/mode if path exists (after mount)
    "z /mnt/games 0775 cleboost users -"
    "z /mnt/data 0775 cleboost users -"
    "d /mnt/games/SteamLibrary 0755 cleboost users -"
    "d /mnt/data/Downloads 0755 cleboost users -"
    "d /mnt/data/Media 0755 cleboost users -"
    "d /mnt/data/Backup 0755 cleboost users -"
  ];
}
