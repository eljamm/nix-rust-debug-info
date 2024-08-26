{
  inputs.nixpkgs.url = "github:eljamm/nixpkgs/nix-naja";
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
          pkgs = nixpkgs.legacyPackages.${system};
          sysrootPkgs = import nixpkgs {
            inherit system;
            crossSystem = {
              inherit system;
              rust.rustcTargetSpec =
                {
                  aarch64-darwin = ./aarch64-apple-darwin.json;
                  x86_64-linux = ./x86_64-unknown-linux-gnu.json;
                }
                .${system};
            };
          };
        in
        {
          naja = pkgs.callPackage ./. { };
        };
    });
}
