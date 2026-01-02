{ config, pkgs, lib, ... }:

# Based on @sleepy from discourse.nix.org configuration.
let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-US" ];

    policies = {
      AppAutoUpdate = false;
      DontCheckDefaultBrowser = true;

      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableFirefoxAccounts = true;
      DisableAccounts = true;
      DisableFirefoxScreenshots = true;

      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";

      EnableTrackingProtection = {
        Value = true; Locked = true;
        Cryptomining = true; Fingerprinting = true;
      };

      # Heavily based on pollyuko's relaxed user.js.
      # TODO: complete it. I'm tired.
      Preferences = {
        "browser.theme.toolbar-theme".Value = 2;
        "browser.theme.content-theme".Value = 2;
        "extensions.activeThemeID".Value = "firefox-compact-dark@mozilla.org";
        "extensions.pocket.enabled" = lock-false;
        "extensions.screenshots.enabled" = lock-false;

        # Disable GeoLocation.
        "geo.enabled" = lock-false;
        "geo.wifi.logging.enabled" = lock-false;
        # Disable raw tcp.
        "dom.mozTCPSocket.enabled" = lock-false;
        # Disable leaking information via Js.
        "dom.netinfo.enabled" = lock-false;
        # Disable webRTC.
        "media.peerconnection.enabled" = lock-false;
        "media.peerconnection.ice.default_address_only" = lock-true;
        "media.peerconnection.ice.no_host" = lock-true;
        "media.navigator.enabled" = lock-false;
        "media.navigator.video.enabled" = lock-false;
        "media.getusermedia.screensharing.enabled" = lock-false;
        "media.getusermedia.audiocapture.enabled" = lock-false;
        # Disable some APIs.
        "dom.battery.enabled" = lock-false;
        "dom.telephony.enabled" = lock-false;
        "dom.gamepad.enabled" = lock-false;
        "dom.vr.enabled" = lock-false;
        "dom.vibrator.enabled" = false;
        "device.sensors.enabled" = lock-false;
        # Disable beacon async http transfers.
        "beacon.enabled" = lock-false;
        # Disable speech recognition and synthesis.
       	"media.webspeech.recognition.enabled" = lock-false;
        "media.webspeech.synth.enabled" = lock-false;
        # Disable ridiculous ping by <a> ping= attributes.
        "browser.send_pings" = lock-false;
        "browser.send_pings.require_same_host" = lock-true;
        # What about webassembly? I like it...
        #"javascrip.options.wasm" = lock-false;
        # Set Accept-Language header to en-US
        "intl.accept_languages".Value = "en-US, en";
        "intl.locale.matchOS" = lock-false;
        # Do not trim HTTP off of URLs.
        "browser.urlbar.trimURLs" = lock-false;
        # JAR should not open unsafe file types.
        "network.jar.open-unsafe-types" = lock-false;
      }; # Preferences
    }; # policies
  }; # programs.firefox
}
