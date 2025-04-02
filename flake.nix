{
  description = "dev env for configurable engine";

  nixConfig = {
    extra-substituters = "https://nixpkgs-ruby.cachix.org";
    extra-trusted-public-keys = "nixpkgs-ruby.cachix.org-1:vrcdi50fTolOxWCZZkw0jakOnUI1T19oYJ+PRYdK4SM=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    ruby-nix.url = "github:inscapist/ruby-nix";
    # a fork that supports platform dependant gem
    bundix = {
      url = "github:inscapist/bundix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fu.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      fu,
      ruby-nix,
      bundix,
    }:
    with fu.lib;
    eachDefaultSystem (
      system:
      let

        assertVersion =
          version: pkg:
          (
            assert (
              pkgs.lib.assertMsg (builtins.toString pkg.version == version) ''
                Expecting version of ${pkg.name} to be ${version} but got ${pkg.version};
              ''
            );
            pkg
          );

        pkgs = import nixpkgs { inherit system; };
        rubyNix = ruby-nix.lib pkgs;

        gemset = if builtins.pathExists ./gemset.nix then import ./gemset.nix else { };

        # If you want to override gem build config, see
        #   https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/ruby-modules/gem-config/default.nix
        gemConfig = { };

        ruby = (assertVersion (pkgs.lib.strings.fileContents "${self}/.ruby-version") pkgs.ruby_3_2);

        # Running bundix regenerate `gemset.nix`
        bundixcli = bundix.packages.${system}.default;

        # Use these instead of the original `bundle <mutate>` commands
        bundleLock = pkgs.writeShellScriptBin "bundle-lock" ''
          export BUNDLE_PATH=vendor/bundle
          bundle lock
        '';
        bundleUpdate = pkgs.writeShellScriptBin "bundle-update" ''
          export BUNDLE_PATH=vendor/bundle
          bundle lock --update
        '';
      in
      rec {
        inherit
          (rubyNix {
            inherit gemset ruby;
            name = "configurable engine";
            gemConfig = pkgs.defaultGemConfig // gemConfig;
          })
          env
          ;

        formatter = pkgs.nixfmt-rfc-style;
        devShells = rec {
          default = dev;
          dev = pkgs.mkShell {
            buildInputs = (
              (with pkgs; [ sqlite ])
              ++ [
                env
                bundixcli
                bundleLock
                bundleUpdate
              ]
            );
          };
        };
      }
    );
}
