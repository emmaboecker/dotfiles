{...}: {
  services.loki = {
    enable = true; 

    configuration = {
      auth_enabled = false;
      server.http_listen_port = 3100;
      server.http_listen_address = "127.0.0.1";

      ingester = {
        lifecycler = {
          address = "127.0.0.1";
          ring = {
            kvstore.store = "inmemory";
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 1048576;
        chunk_retain_period = "30s";
        max_transfer_retries = 0;
      };

      schema_config = {
        configs = [
          {
            from = "2023-07-11";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      storage_config = {
        boltdb_shipper = {
          active_index_directory = "/var/lib/loki/boltdb-shipper-active";
          cache_location = "/var/lib/loki/boltdb-shipper-cache";
          cache_ttl = "48h";
          shared_store = "filesystem";
        };
        filesystem = {
          directory = "/var/lib/loki/chunks";
        };
      };

      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };

      chunk_store_config.max_look_back_period = "0s";

      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };

      compactor = {
        working_directory = "/var/lib/loki";
        shared_store = "filesystem";
        compactor_ring = {
          instance_interface_names = ["ens3"];
          kvstore.store = "inmemory";
        };
      };

      query_scheduler.max_outstanding_requests_per_tenant = 4096;
      frontend.max_outstanding_per_tenant = 4096;
    };
  };

  systemd.services.loki = {
    after = ["network.target"];
    wants = ["network.target"];
  };
}
