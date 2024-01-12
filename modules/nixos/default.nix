rec {
  secrets = ./secrets;

  services = {
    dae = ./services/dae;
  };

  allModules = {
    imports = [
      secrets

      services.dae
    ];
  };
}
