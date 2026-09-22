#!/bin/bash

set -u

ERROS=0

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

cat << "EOF"

        ▄▄▄▄▄▄▄   ▄▄▄      ▄▄▄   ▄▄▄▄    ▄▄▄▄▄▄▄              ▄▄▄
        ███▀▀███▄ ████▄  ▄████ ▄██▀▀██▄ ███▀▀▀▀▀              ███
        ███▄▄███▀ ███▀████▀███ ███  ███ ███       ▄█▀█▄ ████▄ ███      ▄███▄ ▄████
        ███▀▀██▄  ███  ▀▀  ███ ███▀▀███ ███  ███▀ ██▄█▀ ██ ██ ███      ██ ██ ██ ██
        ███  ▀███ ███      ███ ███  ███ ▀██████▀  ▀█▄▄▄ ██ ██ ████████ ▀███▀ ▀████
                                                                                ██
               Autor: Tales Araujo           github.com/talesaraujo777        ▀▀▀

EOF

# ------------------------------------------------------------------------
# Instala o IPMITool
# ------------------------------------------------------------------------

if sudo apt-get install -y ipmitool >/dev/null 2>&1; then
    echo -e "RMAGenLog está em execução..."
else
    echo -e "${RED}[ERRO]${RESET} IPMITool não responde!" 
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# Diretório onde o script fica localizado
# ------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" >/dev/null 2>&1

IP_BMC=$(sudo ipmitool lan print 2>/dev/null | \
    awk -F': ' '/^IP Address[[:space:]]*:/ {print $2}')

MAC_BMC=$(sudo ipmitool lan print 2>/dev/null | \
    awk -F': ' '/^MAC Address[[:space:]]*:/ {print $2}' | \
    tr -d ':' | tr '[:lower:]' '[:upper:]')

LOG_DIR="$SCRIPT_DIR/LOGs/${MAC_BMC}_$(date '+%d-%m-%Y_%H-%M-%S')"

echo
echo -e " IP BMC: $IP_BMC"
echo -e "MAC BMC: $MAC_BMC"
echo

# ------------------------------------------------------------------------
# Cria o diretório dos logs
# ------------------------------------------------------------------------

if mkdir -p "$LOG_DIR"; then
    :
else
    echo -e "${RED}[ERRO]${RESET} Não foi possível criar o diretório de logs!"
    exit 1
fi

cd "$LOG_DIR" || exit 1

# ------------------------------------------------------------------------
# DMI - BASEBOARD
# ------------------------------------------------------------------------

if sudo dmidecode -t baseboard > "$LOG_DIR/log_dmidecode_baseboard.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_dmidecode_baseboard.txt"
else
    echo -e "${RED}[ERRO]${RESET} dmidecode -t baseboard falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# IPMITOOL LAN PRINT
# ------------------------------------------------------------------------

if sudo ipmitool lan print > "$LOG_DIR/log_ipmitool_print.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_ipmitool_print.txt"
else
    echo -e "${RED}[ERRO]${RESET} ipmitool lan print falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# IPMITOOL MC INFO
# ------------------------------------------------------------------------

if sudo ipmitool mc info > "$LOG_DIR/log_ipmitool_info.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_ipmitool_info.txt"
else
    echo -e "${RED}[ERRO]${RESET} ipmitool mc info falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# BIOS
# ------------------------------------------------------------------------

if sudo dmidecode -t bios > "$LOG_DIR/log_dmidecode_bios.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_dmidecode_bios.txt"
else
    echo -e "${RED}[ERRO]${RESET} dmidecode -t bios falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# UNAME
# ------------------------------------------------------------------------

if uname -a > "$LOG_DIR/log_uname.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_uname.txt"
else
    echo -e "${RED}[ERRO]${RESET} uname falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# OS RELEASE
# ------------------------------------------------------------------------

if cat /etc/os-release > "$LOG_DIR/log_osrelease.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_osrelease.txt"
else
    echo -e "${RED}[ERRO]${RESET} os-release falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# PCI
# ------------------------------------------------------------------------

if lspci -nn > "$LOG_DIR/log_lspci.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_lspci.txt"
else
    echo -e "${RED}[ERRO]${RESET} lspci falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# NVIDIA SMI
# ------------------------------------------------------------------------

if nvidia-smi > "$LOG_DIR/log_nvidia-smi.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_nvidia-smi.txt"
else
    echo -e "${RED}[ERRO]${RESET} nvidia-smi falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# NVIDIA SMI -Q
# ------------------------------------------------------------------------

if nvidia-smi -q > "$LOG_DIR/log_nvidia-smi-q.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_nvidia-smi-q.txt"
else
    echo -e "${RED}[ERRO]${RESET} nvidia-smi -q falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# NVIDIA TOPO
# ------------------------------------------------------------------------

if nvidia-smi topo -m > "$LOG_DIR/log_nvidia-smi-topo-m.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_nvidia-smi-topo-m.txt"
else
    echo -e "${RED}[ERRO]${RESET} nvidia-smi topo -m falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# NVIDIA NVLINK
# ------------------------------------------------------------------------

if nvidia-smi nvlink -s > "$LOG_DIR/log_nvidia-nvlink-s.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_nvidia-nvlink-s.txt"
else
    echo -e "${RED}[ERRO]${RESET} nvidia-smi nvlink -s falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# DMESG
# ------------------------------------------------------------------------

if sudo dmesg > "$LOG_DIR/log_dmesg.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_dmesg.txt"
else
    echo -e "${RED}[ERRO]${RESET} dmesg falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# JOURNAL KERNEL
# ------------------------------------------------------------------------

if sudo journalctl -k > "$LOG_DIR/log_journal_kernel.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_journal_kernel.txt"
else
    echo -e "${RED}[ERRO]${RESET} journalctl falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# KERNEL.LOG
# ------------------------------------------------------------------------

if [ -f /var/log/kern.log ]; then

    if sudo cp /var/log/kern.log "$LOG_DIR/log_kernel.txt" 2>/dev/null; then
        echo -e "${GREEN}[OK]${RESET} Gerando log_kernel.txt"
    else
        echo -e "${RED}[ERRO]${RESET} Não foi possível copiar kern.log!"
        ERROS=$((ERROS + 1))
    fi

else
    echo -e "${RED}[ERRO]${RESET} /var/log/kern.log não existe!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# DCGM DIAG
# ------------------------------------------------------------------------

if sudo dcgmi diag -r 3 > "$LOG_DIR/log_dcgm_diag_3.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando log_dcgm_diag_3.txt"
else
    echo -e "${RED}[ERRO]${RESET} dcgmi diag -r 3 falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# NVIDIA BUG REPORT
# ------------------------------------------------------------------------

if sudo /usr/bin/nvidia-bug-report.sh > "$LOG_DIR/output_nvidia_bug_report.txt" 2>/dev/null; then
    echo -e "${GREEN}[OK]${RESET} Gerando nvidia-bug-report.log.gz"
else
    echo -e "${RED}[ERRO]${RESET} nvidia-bug-report.sh falhou!"
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# VERIFICAÇÃO DO BUG REPORT
# ------------------------------------------------------------------------

if [ ! -f "$LOG_DIR/nvidia-bug-report.log.gz" ]; then
    echo -e "${RED}[ERRO]${RESET} nvidia-bug-report.log.gz não foi gerado."
    ERROS=$((ERROS + 1))
fi

# ------------------------------------------------------------------------
# RESUMO
# ------------------------------------------------------------------------

TOTAL=$(find "$LOG_DIR" -maxdepth 1 -type f | wc -l)

echo
echo -e "================================================================="
echo -e "                       PROCESSO FINALIZADO"
echo -e "================================================================="
echo
echo -e "Total de registros coletados: 16/$TOTAL"
echo -e "Total de comandos que falhou: $ERROS"
echo
echo -e "LOGs estão localizados em:"
echo -e "$LOG_DIR"
echo

if [ "$ERROS" -eq 0 ]; then
    echo -e "Status: TODOS OS COMANDOS FORAM EXECUTADOS COM SUCESSO."
else
    :
fi

echo
