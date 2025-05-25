# Boutrik's Dotfiles

Welcome to my personal `dotfiles` repository.  
This repo contains the configuration files and environment setup for all my machines. Each setup is carefully tuned to match its use case.

## Lenovo ThinkPad X270 & T480

<img align="right" width="192px" src="./.media/leno-tp-x270.png">

These two machines are my daily drivers, used for general productivity, programming and writing. Both run similar environments.

One of their best features in my opinion is the dual battery system (internal and external), which provides impressive battery life and allows me to hot-swap batteries without shutting the system down. They also support USB-C charging, so in a pinch, I can charge them with a regular phone charger.

### X270 Hardware

| Component      | Specification |
|:---------------|:--------------|
| **Processor**  | i5-6300u (2 cores, 4 threads) 2.4-3.0 GHz |
| **GPU**        | HD Graphics 520 (~ 0.38 TFLOPS) |
| **Display**    | 12.5" FHD 1920x1080 60Hz |

### T480 Hardware

| Component      | Specification |
|:---------------|:--------------|
| **Processor**  | i5-8350u (4 cores, 8 threads) 1.7-3.6 GHz |
| **GPU**        | UHD Graphics 620 (~ 0.44 TFLOPS) |
| **Memory**     | 8 GiB DDR4 2400 MHz |
| **Disk**       | Liteon CV8-CE128 [w=8.6 GiB/s r=7.7 GiB/s]
| **Display**    | 14" FHD 1920x1080 60Hz |
| **Battery**    | SANYO 01AV419 24 Wh 68.1% (16.4 Wh) |

### Operating System

Both run `NixOS` <img width="16px" src="./.media/nix.png">, customized with a strong emphasis on security and privacy. The configuration is declarative, minimal, and tailored for my personal workflow.

#### Encryption

Since I use them in mobile contexts - such as university or travel - FDE (Full Disk Encryption) is essential to protect sensitive data in case of theft. While I'm also interested in plausible deniability, I have not implemented it yet. Therefore, the SSDs are encrypted using `LUKS2` with `AES-XTS` (chosen over Serpent for AES-NI hardware optimization), `Whirlpool` for hashing, and `Argon2(id)` as the KDF (Key Derivation Function).

#### Environment

My desktop environment is built around `hyprland` as the window manager, with `waybar` providing a functional status bar. For screen locking and display manager, `lightdm`; for launching applications, `rofi`; and for terminal, `alacritty`, paired with the default `bash` shell. `Firefox` handles daily web browsing, and `lazyvim` - a neovim distribution - serves as my text editor.

The visual theme follows hyprland's default palette - mainly blue and black - for a clean, cohesive look. My preferred font is `Agave Nerd Font`, which complements the overall aesthetic. System-wide, I use `systemd-boot` as the bootloader, `glibc` as the libc and `ext4` as the filesystem.

## Acer Nitro 5 AN515-58-58W3

<img align="right" width="192px" src="./.media/acer-nitro-5.png">

The Nitro is my more powerful machine, primarily used for gaming and resource-intensive development such, as Android Studio and other demanding environments.

### Hardware

| Component      | Specification |
|:---------------|:--------------|
| **Processor**  | i5-12450H (8 cores, 12 threads) 2.0-4.4 GHz |
| **GPU**        | RTX 3050 Mobile (~ 4.33 TFLOPS) |
| **Memory**     | 8+8 GiB DDR4 3200 MHz |
| **Disk I**     | SSTC CL1-4D256 [w=7.8 GiB/s r=10.6 GiB/s] |
| **Disk II**    | Micron 3400 MTFDKBA512TFH [w=1.9 GiB/s r=4.3 GiB/s] |
| **Display**    | 15.6" FHD 1920x1080 144Hz |
| **Battery**    | SMP AP18E7M 58.8 Wh 74.0% (43.5 Wh) |

### Operating System

I run a custom `Gentoo` <img width="16px" src="./.media/gentoo.svg"> setup, customized for performance. It also dual-boots with `Windows` <img width="16px" src="./.media/windows.png">, which I use for gaming and sofwares that are Windows-only.

#### Encryption

Since this laptop is mostly used at home, FDE (Full Desk Encryption) is essential to prevent unauthorized access when I'm away or leave it unattended. The lock screen also plays a crucial role, as there are times when I leave the system powered on but locked. Therefore, the SSD is encrypted using `LUKS2` with `AES-XTS` (chosen over Serpent for AES-NI hardware optimization), `SHA-256` for hashing, and `PBKDF2` as the KDF (Key Derivation Function).

#### Environment

`i3wm` as the window manager, `polybar` as the status bar, `xsecurelock` for screen locking, `dmenu` for application launching and `alacritty` serves as my terminal with the default `bash` shell. For daily browsing, I rely on `firefox`, while my coding is handled by `lazyvim` (neovim distribution). Btw I'm using `openrc` instead of `systemd`.

The visual theme follows the Nitro's RGB color scheme - red and black - for a high-contrast look. `Agave Nerd Font` is used system-wide as my font of choice. System-wide, I use `grub` as the bootloader, `glibc` as the libc and `btrfs` as the filesystem.

<!---
## (Planned) Raspberry Pi 5

<img align="right" width="192px" src="./.media/rpi-5.png">

The Rpi is a future addition to my setup, intended to be used as an home server.

I'm still undecided on which operating system to run. Options under consideration include: `OpenBSD`, `Ubuntu Server` and `NixOS`. Once the setup is finalized, it's dotfiles and configuration will be added to this repository under a dedicated `rpi-5` directory.

### Hardware

| Component      | Specification |
|:---------------|:--------------|
| **Processor**  | BCM2712 (4 cores) 2.4 GHz |
| **GPU**        | VideoCore VII (~ 0.05 TFLOPS) |
| **RAM**        | 8 GB LPDDR4X (2133MHz) |
--->

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). Feel free to use, modify, and distribute the code as needed. See the [LICENSE](LICENSE) file for more information.
