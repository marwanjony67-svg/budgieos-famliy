# BudgieOS Family

A multi-edition custom OS starter project. The family shares the BNU kernel foundation and builds separate edition-branded ISO images.

## Build locally (Ubuntu/Debian)

```bash
sudo apt update
sudo apt install -y build-essential gcc-multilib g++-multilib nasm grub-pc-bin xorriso python3
chmod +x scripts/build.sh
./scripts/build.sh
```

ISO files are written to `dist/`. These are experimental BIOS/Legacy bootable starter images, not complete desktop operating systems. Test in QEMU first; do not install on your main PC.

## GitHub Actions

Push to `main` or run **Actions → Build BudgieOS Family ISOs → Run workflow**. The workflow builds and uploads 17 ISO artifacts.

## Scope

- BNU starter kernel: C++ and x86 Assembly
- GRUB BIOS boot path
- One branded ISO per family edition
- Shared kernel foundation; edition names/themes are metadata for now

Drivers, networking, BudgieFS, graphical desktop, installers, and full hardware support are future work.
