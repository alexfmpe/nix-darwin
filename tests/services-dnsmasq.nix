{ config, lib, pkgs, ... }:

with lib;

let
  dnsmasq = pkgs.runCommand "dnsmasq-0.0.0" {} "mkdir $out";
in

{
  services.dnsmasq.enable = true;
  services.dnsmasq.package = dnsmasq;
  services.dnsmasq.addresses = {
    localhost = "127.0.0.1";
  };

  test = ''
    echo >&2 "checking dnsmasq service in /Library/LaunchDaemons"
    grep "org.nixos.dnsmasq" ${config.out}/Library/LaunchDaemons/org.nixos.dnsmasq.plist
    grep "${dnsmasq}/bin/dnsmasq" ${config.out}/Library/LaunchDaemons/org.nixos.dnsmasq.plist
    grep -F -- "--address=/localhost/127.0.0.1" ${config.out}/Library/LaunchDaemons/org.nixos.dnsmasq.plist

    echo >&2 "checking resolver config"
    grep -F "nameserver 127.0.0.1.53" ${config.out}/etc/resolver/localhost
  '';
}
