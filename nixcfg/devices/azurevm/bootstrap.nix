let

  # change this as necessary or leave empty and use ENV vars
  credentials = {
  };

in {
  azurevm = { resources, ...}:  {
    deployment.targetEnv = "azure";
    deployment.azure = credentials // {
      location = "westus";
      size = "Standard_D4_v2";
      networkInterfaces.default.ip.allocationMethod = "Static";
    };

    imports = [ ./azurevm.nix ];
  };
}
