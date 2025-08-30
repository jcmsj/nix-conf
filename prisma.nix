{pkgs,...}:
{
  environment.systemPackages = with pkgs; [
    nodePackages.prisma
    prisma-engines
    postgresql
  ];
  environment.sessionVariables = {
    PRISMA_SCHEMA_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${pkgs.prisma-engines}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = "${pkgs.prisma-engines}/bin/introspection-engine";
    PRISMA_FMT_BINARY = "${pkgs.prisma-engines}/bin/prisma-fmt";
    PRISMA_ENGINES_CHECKSUM_IGNORE_MISSING = "1"; # Ignore missing checksums for engines
  };
}
