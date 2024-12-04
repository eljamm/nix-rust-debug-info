{
  inputs.nixpkgs.url = "github:eljamm/nixpkgs/init/010editor";
  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      eachSystem =
        with nixpkgs.lib;
        f: foldAttrs mergeAttrs { } (map (s: mapAttrs (_: v: { ${s} = v; }) (f s)) systems);
    in
    eachSystem (system: {
      packages =
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
            };
          };
        in
        {
          _010editor = pkgs.callPackage ./. { };
        };
    });
}
