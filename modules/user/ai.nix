{ den, inputs, ... }: {
  den.aspects.ai = {
    homeManager =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.mcp-servers-nix.homeManagerModules.default ];
        programs.opencode = {
          enable = true;
          package = pkgs.opencode.overrideAttrs (old: {
            # https://github.com/NixOS/nixpkgs/issues/582673
            node_modules =
              if old.node_modules.outputHash == "sha256-xfOVcw1+waLVNhFDwzOtzxrUSQEogvn88YomydOlhwc=" then
                old.node_modules.overrideAttrs {
                  outputHash = "sha256-prx9dX7kUvs/E3zopkaPk5LXh3xJAy5sZeum/W8L7cA=";
                }
              else
                old.node_modules;
          });
          enableMcpIntegration = true;
          settings = {
            lsp = true;
          };
        };
        programs.mcp.enable = true;
        mcp-servers.programs = {
          context7.enable = true;
          nixos.enable = true;
          github.enable = true;
          serena = {
            enable = true;
            args = [
              "--open-web-dashboard"
              "false"
            ];
          };
        };
      };
  };
  flake-file.inputs = {
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };
}
