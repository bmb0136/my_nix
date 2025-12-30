{
  config.vim.assistant.avante-nvim = {
    enable = true;
    setupOpts = {
      provider = "ollama";
      providers.ollama = {
        model = "gpt-oss:20b";
        endpoint = "http://127.0.0.1:11434";
        timeout = 15000;
      };
    };
  };
}
