{
  description = ''
    https://github.com/NixOS/nixpkgs/issues/282900
    https://github.com/NixOS/nixpkgs/issues/262131
  '';
  # inputs.nixpkgs.url = "github:nixos/nixpkgs";
  inputs.nixpkgs.url = "github:eljamm/nixpkgs/nix-naja";
  # inputs.nixpkgs.url = "/Users/n8henrie/git/nixpkgs";
  # inputs.nixpkgs.url = "/home/n8henrie/git/nixpkgs";
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
          debug = pkgs.callPackage ./. { buildType = "debug"; };
          release = pkgs.callPackage ./. { buildType = "release"; };
          sysroot-debug = sysrootPkgs.callPackage ./. { buildType = "debug"; };
          sysroot-release = sysrootPkgs.callPackage ./. { buildType = "release"; };
        };
    });
}
