{ ... }: 
{
  users.users.emma = {
    isNormalUser = true;
    description = "Emma Böcker";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;

    users.emma = {
      imports = [
        ../../home
      ];

      config.home = {
        username = "emma";
        homeDirectory = "/home/emma";
        stateVersion = "23.11";
      };
    };
  };
}