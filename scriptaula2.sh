#Script criado para a aula 2 do curso Redscan
!/bin/bash
file="access.log"

# Definições de cores
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

while true; do
        clear
        echo -e "${RED}************** Log Ananlizer -- Menu **************${RESET}"
        echo -e "${YELLOW}1  ${RESET}  - Xss Attack"
        echo -e "${YELLOW}2  ${RESET}  - SQL Injection"
        echo -e "${YELLOW}3  ${RESET}  - Directory Traversal"
        echo -e "${YELLOW}4  ${RESET}  - Suspect User-Agent"
        echo -e "${YELLOW}5  ${RESET}  - Access to Sensitive Files"
        echo -e "${YELLOW}6  ${RESET}  - Brute Force Attack (requisições 404)"
        echo -e "${YELLOW}7  ${RESET}  - First and last access from a suspicious IP"
        echo -e "${YELLOW}8  ${RESET}  - User-Agent used by a suspicious IP"
        echo -e "${YELLOW}9  ${RESET}  - List IPs and number of requests"
        echo -e "${YELLOW}10 ${RESET}  - Locate access to a specific sensitive file"
        echo -e "${YELLOW}0  ${RESET}  - Exit"
        echo -e "${RED}****************************************************${RESET}"
        read -p "Choose an option: " option

        case $option in
        1)
         echo "[+] Buscando possíveis ataques XSS..."
         grep -iE "<script|%3Cscript" "$file"
         ;;
        2)
         echo "[+] Buscando possíveis tentativas de SQL Injection..."
         grep -iE "union|select|insert|drop|%27|%22" "$file"
         ;;
        3)
         echo "[+] Buscando tentativas de Directory Traversal..."
         grep -E "\.\./|\.\.%2f" "$file"
         ;;
        4)
         echo "[+] Buscando User-Agents suspeitos (ferramentas de scanner)..."
         grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python" "$file"
         ;;
        5)
         echo "[+] Buscando acesso a arquivos sensíveis (.env, .git, etc.)..."
         grep -iE "\.env|\.git|\.htaccess|\.bak" "$file"
         ;;
        6)
         echo "[+] Listando IPs com mais erros 404 (possível brute force)..."
         grep " 404 " "$file" | cut -d " " -f 1 | sort | uniq -c | sort -nr | head
         ;;
        7)
         read -p "Informe o IP suspeito: " ip
         echo "[+] Primeiro acesso do IP $ip:"
         grep "$ip" "$file" | head -n1
         echo "[+] Último acesso do IP $ip:"
         grep "$ip" "$file" | tail -n1
      ;;
    8)
      read -p "Informe o IP suspeito: " ip
      echo "[+] User-Agent(s) do IP $ip:"
      grep "$ip" "$file" | cut -d '"' -f6 | sort | uniq
      ;;
    9)
      echo "[+] Listando IPs e número de requisições:"
      cut -d " " -f1 "$file" | sort | uniq -c | sort -nr
      ;;
    10)
      read -p "Informe o nome do arquivo sensível (ex: .env): " arq
      echo "[+] Buscando acessos ao arquivo $arq:"
      grep "$arq" "$file"
      ;;
    0)
      echo "Saindo..."
      break
      ;;
    *)
      echo "Opção inválida. Tente novamente."
      ;;
  esac
  echo ""
  read -p  "Pressione ENTER para continuar..."

done
