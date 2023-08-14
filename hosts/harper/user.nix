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
}