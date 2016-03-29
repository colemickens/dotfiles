let

  # change this as necessary or leave empty and use ENV vars
  credentials = {
  };

in {
  azurevm = { resources, ...}:  {
    deployment.targetEnv = "azure";
    deployment.azure = credentials // {
      location = "westus";
      size = "Standard_DS4";
      networkInterfaces.default.ip.allocationMethod = "static";
    };

    imports = [ ./azurevm.nix ];
  };
}
