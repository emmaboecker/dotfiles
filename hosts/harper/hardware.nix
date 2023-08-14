{ config, lib, modulesPath, ... }:
{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" "rtsx_usb_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/446f86ce-50eb-4c8b-ba44-ece13bca5d47";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."luks-a985d1c5-bb91-46e0-a6f8-3a8e976bf969".device = "/dev/disk/by-uuid/a985d1c5-bb91-46e0-a6f8-3a8e976bf969";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/15E5-56FC";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c20c0ed1-f596-453d-ab82-4144a210edee"; }
    ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}