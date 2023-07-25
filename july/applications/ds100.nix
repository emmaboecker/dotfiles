{ ... }: 
{
  uwumarie.reverse-proxy.services."ds100.boecker.dev" = {
    locations."/" = {
      index = "index.html";
      root = "/var/lib/ds100/";
      extraConfig = ''
        add_header Access-Control-Allow-Origin "*";
      '';
    };
  };
}