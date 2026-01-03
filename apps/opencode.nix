{
  config,
  lib,
  ...
}:
{
  home-manager = lib.mkIf config.services.ollama.enable {
    sharedModules = [
      {
        programs.opencode = {
          enable = true;
          settings = {
            model = "ollama/gpt-oss:20b";
            small_model = "ollama/llama3.2:3b";
            provider = {
              ollama = {
                npm = "@ai-sdk/openai-compatible";
                name = "Ollama (local)";
                options = {
                  baseURL = "http://${config.services.ollama.host}:${toString config.services.ollama.port}";
                };
                models = {
                  "gpt-oss:20b" = {
                    name = "GPT OSS (20b)";
                  };
                  "llama3.2:3b" = {
                    name = "Llama 3.2 (3b)";
                  };
                };
              };
            };
          };
        };
      }
    ];
  };
}
