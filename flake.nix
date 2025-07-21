{
  description = "Nmap for ssh";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs, ... }:

  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
  packages.${system}.default = pkgs.stdenv.mkDerivation {
    pname = "ssher";
    version = "1.0";
    unpackPhase = "true";
    buildInputs = [ pkgs.makeWrapper ];
    src = ./ssher;
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/ssher
      chmod +x $out/bin/ssher
      wrapProgram $out/bin/ssher --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.sshpass ] }
    '';
    };
  };
}
