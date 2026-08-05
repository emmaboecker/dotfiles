{ pkgs, ...}: {
  users.users.lou = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
    ];
    useDefaultShell = true;
  };
}