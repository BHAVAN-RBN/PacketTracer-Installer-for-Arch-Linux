<div align="center">

# Packet Tracer Installer for Arch Linux

**One command to install Cisco Packet Tracer 9.x from the official Ubuntu `.deb` on Arch Linux and Arch-based systems.**

![Platform: Arch Linux](https://img.shields.io/badge/platform-Arch%20Linux-1793D1?logo=arch-linux&logoColor=white)
![Shell: Bash](https://img.shields.io/badge/shell-bash-4EAA25?logo=gnu-bash&logoColor=white)
![License: MIT](https://img.shields.io/badge/license-MIT-green)

<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 900 480" width="100%" height="100%">
  <defs>
    <style>
      .bg { fill: #1e1e2e; }
      .box { fill: #313244; stroke: #45475a; stroke-width: 2; rx: 8; }
      .accent-box { fill: #2b2b40; stroke: #89b4fa; stroke-width: 2; rx: 8; }
      .title { fill: #cdd6f4; font-family: system-ui, sans-serif; font-weight: bold; font-size: 16px; }
      .subtitle { fill: #a6adc8; font-family: system-ui, sans-serif; font-size: 12px; }
      .code { fill: #f38ba8; font-family: monospace; font-size: 11px; }
      .arrow { stroke: #a6e3a1; stroke-width: 2.5; fill: none; marker-end: url(#arrowhead); }
    </style>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="6" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#a6e3a1"/>
    </marker>
  </defs>

  <!-- Background -->
  <rect width="900" height="480" class="bg"/>

  <!-- Header -->
  <text x="450" y="40" text-anchor="middle" fill="#cdd6f4" font-family="system-ui, sans-serif" font-weight="bold" font-size="22">Cisco Packet Tracer 9.x Installer for Arch Linux</text>
  <text x="450" y="65" text-anchor="middle" fill="#a6adc8" font-family="system-ui, sans-serif" font-size="13">Workflow of packettracer_installer.sh</text>

  <!-- Step 1: Input Deb -->
  <rect x="40" y="120" width="160" height="110" class="box"/>
  <text x="120" y="145" text-anchor="middle" class="title">1. Input</text>
  <text x="120" y="165" text-anchor="middle" class="subtitle">Official Ubuntu .deb</text>
  <text x="120" y="190" text-anchor="middle" class="code">ar x package.deb</text>
  <text x="120" y="210" text-anchor="middle" class="code">extract data.tar.*</text>

  <!-- Arrow 1 -->
  <path d="M 205 175 L 255 175" class="arrow"/>

  <!-- Step 2: Inspection / Verification -->
  <rect x="260" y="120" width="160" height="110" class="box"/>
  <text x="340" y="145" text-anchor="middle" class="title">2. Validate</text>
  <text x="340" y="165" text-anchor="middle" class="subtitle">Check Root &amp; Tools</text>
  <text x="340" y="190" text-anchor="middle" class="code">require root/sudo</text>
  <text x="340" y="210" text-anchor="middle" class="code">find *.AppImage</text>

  <!-- Arrow 2 -->
  <path d="M 425 175 L 475 175" class="arrow"/>

  <!-- Step 3: Dependencies -->
  <rect x="480" y="120" width="160" height="110" class="box"/>
  <text x="560" y="145" text-anchor="middle" class="title">3. Dependencies</text>
  <text x="560" y="165" text-anchor="middle" class="subtitle">Arch Pacman</text>
  <text x="560" y="190" text-anchor="middle" class="code">pacman -S</text>
  <text x="560" y="210" text-anchor="middle" class="code">--needed fuse2</text>

  <!-- Arrow 3 -->
  <path d="M 645 175 L 695 175" class="arrow"/>

  <!-- Step 4: Installation -->
  <rect x="700" y="120" width="160" height="110" class="accent-box"/>
  <text x="780" y="145" text-anchor="middle" class="title">4. Deploy</text>
  <text x="780" y="165" text-anchor="middle" class="subtitle">System Integration</text>
  <text x="780" y="190" text-anchor="middle" class="code">Copy /opt &amp; /usr</text>
  <text x="780" y="210" text-anchor="middle" class="code">chmod +x AppImage</text>

  <!-- Bottom Section: Launcher Creation -->
  <rect x="260" y="300" width="380" height="120" class="box"/>
  <text x="450" y="330" text-anchor="middle" class="title">5. Create CLI Launcher</text>
  <text x="450" y="355" text-anchor="middle" class="subtitle">Writes wrapper script to global execution path</text>
  <text x="450" y="380" text-anchor="middle" class="code">/usr/local/bin/packettracer</text>
  <text x="450" y="400" text-anchor="middle" fill="#89b4fa" font-family="monospace" font-size="10">exec /opt/pt/packettracer.AppImage "$@"</text>

  <!-- Connecting Arrow from Deploy to Launcher -->
  <path d="M 780 230 L 780 265 L 560 265 L 560 295" class="arrow"/>
</svg>

<img width="281" height="150" alt="how-it-works" src="https://github.com/user-attachments/assets/2d7543fa-7ce1-43f9-b927-ce051522b320" />


</div>

## Table of contents

- [Why this exists](#why-this-exists)
- [Requirements](#requirements)
- [Quick start](#quick-start)
- [How it works](#how-it-works)
- [Options](#options)
- [Troubleshooting](#troubleshooting)
- [Uninstall](#uninstall)
- [Security notes](#security-notes)
- [Contributing](#contributing) · [License](#license) · [Author](#author)

## Why this exists

Cisco distributes Packet Tracer for Linux only as an Ubuntu `.deb`. Packet Tracer 8.x used a classic Debian file tree, but **9.x ships a single AppImage inside `/opt/pt`**, with no `usr` tree. Scripts written for the old layout check for folders that no longer exist and stop with errors such as `Invalid Packet Tracer file data`.

This installer reads the package, finds the AppImage wherever it is, and installs it with a `packettracer` launcher.

## Requirements

- Arch Linux or an Arch-based distribution (`pacman` available)
- The official `.deb` from your own [Cisco Networking Academy ↗](https://www.netacad.com/) account
- `binutils` (provides `ar`) and `sudo`

## Quick start

```bash
git clone https://github.com/BHAVAN-RBN/PacketTracer-Installer-for-Arch-Linux.git
cd PacketTracer-Installer-for-Arch-Linux

# Optional: see what is inside the package first (no root, installs nothing)
./packettracer_installer.sh --inspect ~/Downloads/CiscoPacketTracer_901_Ubuntu_64bit.deb

# Install
sudo ./packettracer_installer.sh ~/Downloads/CiscoPacketTracer_901_Ubuntu_64bit.deb

# First run, as your normal user, in a terminal: accept the license
packettracer
```

The first run has to happen in a terminal. Packet Tracer asks you to accept Cisco's license there, and no desktop entry exists until that has been done.

## How it works

<img src="docs/images/how-it-works.svg" alt="Workflow of packettracer_installer.sh: input, validate, dependencies, deploy, CLI launcher" width="100%">

1. **Input:** unpacks the official `.deb` (`ar x`, then the `data.tar.*` archive) into a temporary directory that is removed when the script exits.
2. **Validate:** checks for root privileges and the required tools, then finds the AppImage inside the package. If there is none, the script prints the package contents and stops before changing anything on your system.
3. **Dependencies:** installs `fuse2` with `pacman`, which AppImages need to run.
4. **Deploy:** copies the package's `/opt` files into place and marks the AppImage executable.
5. **CLI launcher:** creates `/usr/local/bin/packettracer`, a small wrapper that starts the AppImage.

## Options

| Command | Effect |
|---|---|
| `sudo ./packettracer_installer.sh <file.deb>` | Install Packet Tracer |
| `./packettracer_installer.sh --inspect <file.deb>` | List the files inside the package and exit. Needs no root and installs nothing |
| `./packettracer_installer.sh --help` | Show usage |

## Troubleshooting

| Symptom | What to do |
|---|---|
| `No AppImage found in this package` | Run with `--inspect` and open an issue with the output. The package layout may have changed. |
| `Could not unpack data.tar...` | The package uses zstd compression. Install it with `sudo pacman -S zstd` and retry. |
| `Root privileges are required` | Run the install with `sudo`. `--inspect` does not need it. |
| `packettracer: command not found` | Make sure `/usr/local/bin` is in your `PATH` (it is by default on Arch). Open a new terminal. |
| The app does not start | Run `packettracer` in a terminal and read the error. Check that `fuse2` is installed. As a test without FUSE, try `packettracer --appimage-extract-and-run`. |
| The Login button does not open a browser (KDE Plasma 6) | Some users report this because the AppImage's bundled libraries leak into the environment of the browser launcher. Check the comments on the AUR `packettracer` package for workarounds. |

## Uninstall

```bash
sudo rm -rf /opt/pt /usr/local/bin/packettracer
```

Also remove any desktop entries created by the first run.

## Security notes

- **Trust the source.** Only install a `.deb` you downloaded from Cisco yourself. Installing runs code as root.
- **Read the script.** It is short on purpose. Review it before running anything with `sudo`.
- **Look first.** `--inspect` shows the package contents before you commit to an install.

> **Disclaimer.** Cisco Packet Tracer is proprietary software. This project is not affiliated with or endorsed by Cisco, does not distribute Packet Tracer, and requires you to obtain the `.deb` from Cisco yourself under its license.

## Contributing

Issues and pull requests are welcome. If something fails, please include your Arch version, the exact command, the full terminal output, and the output of `--inspect`. Please run `shellcheck packettracer_installer.sh` before opening a pull request.

## License

Released under the [MIT License](LICENSE).

## Author

**BHAVAN-RBN**: cybersecurity trainer and freelance penetration tester (eCPPTv3, CRTA).

[![GitHub](https://img.shields.io/badge/GitHub-BHAVAN--RBN-181717?logo=github&logoColor=white)](https://github.com/BHAVAN-RBN)
