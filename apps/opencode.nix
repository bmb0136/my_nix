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
            model = "ollama/qwen2.5-coder:14b";
            small_model = "ollama/llama3.2:3b";
            provider = {
              ollama = {
                npm = "@ai-sdk/openai-compatible";
                name = "Ollama (local)";
                options = {
                  baseURL = "http://${config.services.ollama.host}:${toString config.services.ollama.port}/v1";
                };
                models = {
                  "qwen2.5-coder:14b" = {
                    name = "Qwen 2.5 Coder (14b)";
                    tools = true;
                    reasoning = true;
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
