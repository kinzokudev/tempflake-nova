{
  inputs,
  outputs,
  userinfo,
  hostname,
  ...
}:
{
  imports = [
    ./core
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
  ];
  home-manager = {
    extraSpecialArgs = {
      inherit
        inputs
        outputs
        userinfo
        hostname
        ;
    };
    useGlobalPkgs = false;
    useUserPackages = true;
    users = {
      ${userinfo.name} = import ./hm;
    };
    backupFileExtension = "backup";
  };
}
