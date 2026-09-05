# pcopy / pmove — Parallel Copy/Move

Hardware-aware parallel file copy and move operations that exploit NVMe multi-queue architecture, PCIe lane bandwidth, and multi-core CPUs to copy many files simultaneously.

## Why

Standard `cp` and `mv` operate sequentially — one file at a time, one read/write per chunk. Modern NVMe SSDs expose **multiple hardware submission queues** (typically one per CPU core) and sit on **PCIe Gen4 x4** links providing ~7 GB/s of bandwidth. A single-threaded copy barely uses one queue and achieves ~2-3 GB/s at best.

`pcopy` dispatches multiple files across multiple channels simultaneously. Each channel runs on its own CPU, submitting I/O to its own NVMe hardware queue. The NVMe controller processes all queues in parallel. Result: near-linear throughput scaling until the PCIe link saturates.

## Theory of Operation

```
                    Standard cp (sequential)
                    ════════════════════════
File 1: [████████████████████████████]
File 2:                               [████████████████████████████]
File 3:                                                             [████████]
         └────────────────── Time ──────────────────────────────────────────┘

                    pcopy (parallel, 3 channels)
                    ════════════════════════════
File 1: [████████████████████████████]
File 2: [████████████████████████████]           (concurrent)
File 3: [████████]                               (concurrent)
         └────── Time ──────┘

Speedup ≈ min(CPUs, HW_Queues, nr_files) × single_stream_throughput
           capped by PCIe bandwidth
```

## Hardware Detection

pcopy auto-detects:

| Parameter | Source | Example |
|-----------|--------|---------|
| Online CPUs | `num_online_cpus()` | 8 |
| NVMe HW Queues | `request_queue->nr_hw_queues` | 8 |
| PCIe Generation | PCI Express Link Status register | Gen4 |
| PCIe Lanes | PCI Express Link Status register | x4 |
| Total Bandwidth | Gen × Lanes × per-lane rate | 7876 MB/s |

## Channel Formula

```
channels = min(online_cpus, nr_hw_queues, nr_files)
```

- **More channels than CPUs** → context switch overhead exceeds benefit
- **More channels than HW queues** → software queuing only, no hardware parallelism
- **More channels than files** → idle channels, waste
- **PCIe bandwidth** → hard cap regardless of queue/CPU count

## Usage

```bash
pcopy *.log /backup/logs/
pcopy -j 8 -p data/ images/ /mnt/backup/
pmove -p /old/location/ /new/location/
pcopy --status
pcopy -n project/ /backup/
```

## Options

| Flag | Description |
|------|-------------|
| `-j N` | Force N parallel channels (default: auto) |
| `-c SIZE` | Chunk size in KB (default: auto-tune) |
| `-s` | fsync after each file |
| `-p` | Preserve permissions and timestamps |
| `-f` | Force overwrite existing files |
| `-v` | Verbose (show per-file status) |
| `-n` | Dry run |
| `--status` | Show hardware status and exit |

## Build

```bash
cd tools/pcopy && make && sudo make install
```

## Cross-Device Move

When `pmove` encounters a cross-device situation, it attempts `rename()`, falls back on copy/unlink for `EXDEV`, and preserves requested attributes.

## License

GPL-2.0

## Copyright

Copyright (C) 2026 MEARVK LLC
Author: Maximilian Eric Alexander Rupplin von Keffikon
