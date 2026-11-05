# OpenCode Egress Lab

Docker lab dengan:
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
