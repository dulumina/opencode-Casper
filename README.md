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

## Prasyarat

- Docker + Docker Compose
- `jq` di host (dipakai oleh `./egress` dan generator config)

## Menjalankan

    docker compose build
    docker compose up -d
    docker compose exec agent opencode

## Egress

Semua perintah egress dijalankan dari root project:

    ./egress status              # proxy aktif, EgressRegion, dan IP keluar
    ./egress direct              # tanpa proxy (koneksi langsung)
    ./egress psiphon             # kembali memakai Psiphon
    ./egress psiphon auto        # Psiphon pilih region otomatis
    ./egress psiphon region SG   # pilih region tertentu

Region yang tersedia: `auto`, `de`, `fr`, `gb`, `id`, `jp`, `nl`, `sg`, `us`.

Cara kerja `./egress`:

1. Menulis `EGRESS_ENV_FILE` ke `.env`.
2. Me-recreate container `agent` agar env proxy baru terpakai.
3. Menunggu egress siap (maksimal sekitar 90 detik).

Saat pindah region, `config/psiphon/psiphon.config` diganti dan salinan
sebelumnya disimpan di `config/psiphon/psiphon.config.backup`.

### Membuat ulang config region

    ./generate-psiphon-configs.sh

Script mengambil `base.config` dari container proxy (jika belum ada), lalu
menulis ulang semua config di `config/psiphon/regions/`. Container proxy harus
sudah berjalan.

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
