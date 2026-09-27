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
          web.enable = true;
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
          serena.enable = true;
        };
      };
  };
  flake-file.inputs = {
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };
}
