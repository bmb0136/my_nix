{ pkgs, config, ... }:
{
  config = {
    stylix = {
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrains Mono Nerd Font";
        };
        emoji = {
          package = pkgs.stdenv.mkDerivation {
            name = "twemoji-hack";
            installPhase = ''
              mkdir -p $out/share/fonts/truetype
              cp "${pkgs.twitter-color-emoji}/share/fonts/truetype/TwitterColorEmoji.ttf" "$out/share/fonts/truetype/TwitterColorEmoji-SVGinOT.ttf"
            '';
            dontUnpack = true;
          };
          name = "Twitter Color Emoji";
        };
      };
    };

    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
        #useEmbeddedBitmaps = true;
        localConf = ''
          <?xml version='1.0'?>
          <!DOCTYPE fontconfig SYSTEM 'urn:fontconfig:fonts.dtd'>
          <fontconfig>
            <alias binding="same">
              <family>sans-serif</family>
              <prefer>
                <family>${config.stylix.fonts.sansSerif.name}</family>
                <family>${config.stylix.fonts.emoji.name}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>serif</family>
              <prefer>
                <family>${config.stylix.fonts.serif.name}</family>
                <family>${config.stylix.fonts.emoji.name}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>monospace</family>
              <prefer>
                <family>${config.stylix.fonts.monospace.name}</family>
                <family>${config.stylix.fonts.emoji.name}</family>
              </prefer>
            </alias>
            <alias binding="same">
              <family>emoji</family>
              <prefer>
                <family>${config.stylix.fonts.emoji.name}</family>
              </prefer>
            </alias>
          </fontconfig>
        '';
      };
    };
  };
}
