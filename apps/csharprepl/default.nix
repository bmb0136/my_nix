{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  makeWrapper,
  lib,
}:
let
  dotnet = dotnetCorePackages.sdk_10_0;
in
buildDotnetModule (finalAttrs: {
  pname = "csharprepl";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "waf";
    repo = "CSharpRepl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ykHTosYRVNNlMJKFO7X9WQS7/e040EIlS1dt3l7m3xI=";
  };

  projectFile = "CSharpRepl/CSharpRepl.csproj";
  nugetDeps = ./deps.json;

  # Newer MTP-based tests (e.g., in xunit v3) use different args, which breaks dotnetCheckPhase (cannot be fixed with this derivation's dotnetTestFlags)
  # Offending source: https://github.com/NixOS/nixpkgs/blob/699dff80593b575eaf6a6c40e81a2475f4d89c22/pkgs/build-support/dotnet/build-dotnet-module/hook/dotnet-hook.sh#L209
  # Specifically, --maxcpucount and --logger don't exist anymore
  # Also, this project's tests break under nix
  #testProjectFile = "Tests/CSharpRepl.Tests/CSharpRepl.Tests.csproj";
  #doCheck = true;

  dotnet-sdk = dotnet;
  # We're using an SDK here because it's a REPL, and it requires an SDK instead of a runtime
  dotnet-runtime = dotnet;

  # Manually rename output binary
  executables = [ ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/lib/${finalAttrs.pname}/CSharpRepl $out/bin/${finalAttrs.pname} \
      --set DOTNET_ROOT "${dotnet}/share/dotnet"
  '';

  meta = {
    description = "C# REPL with syntax highlighting";
    homepage = "https://fuqua.io/CSharpRepl";
    changelog = "https://github.com/waf/CSharpRepl/blob/main/CHANGELOG.md";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ _4evy ];
    mainProgram = finalAttrs.pname;
  };
})
