<p align="center">
  <img src="assets/casper.svg" alt="Casper" width="120" height="120">
</p>

<h1 align="center">Casper</h1>

<p align="center">
  <img src="assets/opencode.png" alt="OpenCode" width="20" height="20" valign="middle">
  Docker lab untuk <a href="https://opencode.ai">OpenCode</a> di balik Psiphon dan proxy.
</p>

Casper menyediakan:
- OpenCode CLI
- Psiphon community image
- HTTP proxy
- SOCKS proxy
- Persistent workspace

## Menjalankan

    docker compose build
    docker compose up -d

## OpenCode

    docker compose exec agent opencode

## Cek IP melalui proxy

    docker compose exec agent \
      curl -sS -x http://proxy:8080 \
      https://api.ipify.org

## Logs

    docker compose logs -f proxy

## Stop

    docker compose down

## Catatan

Image Psiphon yang digunakan merupakan image komunitas.
Periksa entrypoint, konfigurasi, dan port aktual sebelum digunakan.

Konfigurasi ini belum mengimplementasikan IP rotation otomatis
atau kill switch.
