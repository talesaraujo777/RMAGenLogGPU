                        ▄▄▄▄▄▄▄   ▄▄▄      ▄▄▄   ▄▄▄▄    ▄▄▄▄▄▄▄              ▄▄▄
                        ███▀▀███▄ ████▄  ▄████ ▄██▀▀██▄ ███▀▀▀▀▀              ███
                        ███▄▄███▀ ███▀████▀███ ███  ███ ███       ▄█▀█▄ ████▄ ███      ▄███▄ ▄████
                        ███▀▀██▄  ███  ▀▀  ███ ███▀▀███ ███  ███▀ ██▄█▀ ██ ██ ███      ██ ██ ██ ██
                        ███  ▀███ ███      ███ ███  ███ ▀██████▀  ▀█▄▄▄ ██ ██ ████████ ▀███▀ ▀████
                                                                                                ██
                                                                                              ▀▀▀
Ferramenta para coleta automatizada de logs e informações de diagnóstico 
de servidores equipados com GPUs NVIDIA. Desenvolvida para auxiliar nos 
processos de troubleshooting, validação de hardware e abertura de RMA, 
centralizando informações do sistema, das GPUs, do kernel etc., 
em uma estrutura organizada de logs.

---

## 📋 Sobre

O `RMAGenLogGPU` automatiza a coleta de informações técnicas necessárias
para análise de servidores com GPUs NVIDIA.

Durante a execução, a ferramenta identifica automaticamente o IP e o MAC
do BMC e utiliza o MAC como identificador do diretório da máquina.

## 🧪 Fluxo de execução
```text
                                       ┌─────────────────────────┐
                                       │     RMAGenLogGPU        │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ Identifica BMC          │
                                       │ IP + MAC                │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ Cria diretório de logs  │
                                       │ baseado no MAC do BMC   │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ Coleta informações      │
                                       │ de hardware             │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ Coleta informações de   │
                                       │ GPU NVIDIA              │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ Coleta Kernel / dmesg   │
                                       │ / journal               │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │ NVIDIA Bug Report       │
                                       └────────────┬────────────┘
                                                    │
                                                    ▼
                                       ┌─────────────────────────┐
                                       │       COLETA OK         │
                                       └─────────────────────────┘
```

## 🚀 Utilização
Executando o script
```text
git clone https://github.com/talesaraujo777/RMAGenLogGPU.git

cd RMAGenLogGPU

chmod +x RMAGenLogGPU.sh

sudo ./RMAGenLogGPU.sh

```
## 📦 Resultado da coleta

Após a execução, os arquivos estarão disponíveis em:
```text
LOGs/<MAC_BMC>/<DATA>_<HORA>/
```
Exemplo:
```text
LOGs/
└── 3C2C30ABCDEF/
    └── 11-09-2026_15-30-45/
        ├── log_dmidecode_baseboard.txt
        ├── log_ipmitool_print.txt
        ├── log_ipmitool_info.txt
        ├── log_dmidecode_bios.txt
        ├── log_uname.txt
        ├── log_osrelease.txt
        ├── log_lspci.txt
        ├── log_nvidia-smi.txt
        ├── log_nvidia-smi-q.txt
        ├── log_nvidia-smi-topo-m.txt
        ├── log_nvidia-nvlink-s.txt
        ├── log_dmesg.txt
        ├── log_journal_kernel.txt
        ├── log_kernel.txt
        ├── output_nvidia_bug_report.txt
        └── nvidia-bug-report.log
```

<p align="center"> Desenvolvido por <strong>Tales</strong> 🐧 </p>
