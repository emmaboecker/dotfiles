{...}: {
  imports = [
    ./grafana.nix
    ./exporters.nix
    ./victoriametrics.nix
    ./victorialogs.nix
    ./changedetection-io.nix
  ];
}
