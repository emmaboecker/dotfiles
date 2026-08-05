{
  config,
  self,
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.cifs-utils ];

  age.secrets.media-samba-credentials.file = "${self}/secrets/samba/media-samba-credentials.age";

  fileSystems."/mnt/media" = {
    device = "//u541952-sub3.your-storagebox.de/u541952-sub3";
    fsType = "cifs";
    options = [
      "credentials=${config.age.secrets.media-samba-credentials.path}"
      "x-systemd.automount"
      "noauto"
      "nofail"
      "uid=989"
      "gid=986"
      "file_mode=0660"
      "dir_mode=0770"
      "noserverino"
      "seal"
    ];
  };
}
