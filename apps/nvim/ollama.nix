{
  config.vim.assistant.avante-nvim = {
    enable = true;
    setupOpts = {
      provider = "ollama";
      providers.ollama = {
        endpoint = "http://127.0.0.1:11434";
        timeout = 15000;
      };
    };
  };
}
