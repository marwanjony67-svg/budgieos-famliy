#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"; DIST="$ROOT/dist"
mkdir -p "$BUILD" "$DIST"
for tool in nasm g++ ld grub-mkrescue python3; do command -v "$tool" >/dev/null || { echo "Missing tool: $tool"; exit 1; }; done
nasm -f elf32 "$ROOT/src/boot.asm" -o "$BUILD/boot.o"
g++ -m32 -std=c++20 -ffreestanding -fno-exceptions -fno-rtti -fno-stack-protector -fno-pic -fno-pie -O2 -c "$ROOT/src/kernel.cpp" -o "$BUILD/kernel.o"
ld -m elf_i386 -Ttext 0x100000 -e _start -nostdlib "$BUILD/boot.o" "$BUILD/kernel.o" -o "$BUILD/kernel.elf"
python3 - "$ROOT" "$BUILD" "$DIST" <<'PY'
import json,pathlib,shutil,subprocess,sys
root,build,dist=map(pathlib.Path,sys.argv[1:])
editions=json.loads((root/'editions/editions.json').read_text())['editions']
for e in editions:
 stage=build/('iso-'+e['id'])
 if stage.exists(): shutil.rmtree(stage)
 (stage/'boot/grub').mkdir(parents=True)
 shutil.copy2(build/'kernel.elf',stage/'boot/kernel.elf')
 cfg=(root/'grub/grub.cfg').read_text().replace('BudgieOS Family (BNU starter)',e['name']+' (BNU starter)')
 (stage/'boot/grub/grub.cfg').write_text(cfg)
 subprocess.run(['grub-mkrescue','-o',str(dist/(e['id']+'.iso')),str(stage)],check=True)
 print('Created',e['id']+'.iso')
PY
