#!/bin/bash

# ==============================================
# SCRIPT CATATAN UTANG KANTIN + ROKOK
# Created by : Laksamana
# Support : Indonesia & Malaysia
# ==============================================

DATA_FILE="utang_kantin.txt"
DATA_ROKOK="utang_rokok.txt"
negara=""
mata_uang=""

logo() {
    echo -e "\e[1;33m"
    echo "   ██╗     ██╗███╗   ███╗ █████╗ "
    echo "   ██║     ██║████╗ ████║██╔══██╗"
    echo "   ██║     ██║██╔████╔██║███████║"
    echo "   ██║     ██║██║╚██╔╝██║██╔══██║"
    echo "   ███████╗██║██║ ╚═╝ ██║██║  ██║"
    echo "   ╚══════╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝"
    echo -e "\e[0m"
    echo -e "\e[1;34mTek\e[0m"
    echo -e "\e[1;36m>>>-{ created by : Laksamana }-<<<\e[0m"
    echo ""
}

pilih_negara() {
    clear
    logo
    echo -e "\e[1;35m========== PILIH NEGARA ==========\e[0m"
    echo "1. 🇮🇩 Indonesia (Rp - Rupiah)"
    echo "2. 🇲🇾 Malaysia (RM - Ringgit)"
    echo ""
    read -p "Pilih negara [1/2]: " pilih

    case $pilih in
        1)
            negara="Indonesia"
            mata_uang="Rp"
            echo -e "\e[1;32m✓ Menggunakan Rupiah (Rp)\e[0m"
            ;;
        2)
            negara="Malaysia"
            mata_uang="RM"
            echo -e "\e[1;32m✓ Menggunakan Ringgit (RM)\e[0m"
            ;;
        *)
            echo -e "\e[1;31mPilihan salah! Default ke Indonesia.\e[0m"
            negara="Indonesia"
            mata_uang="Rp"
            ;;
    esac
    sleep 1
}

get_tanggal() {
    local pilihan=$1
    if [[ $pilihan == "1" ]]; then
        if [[ $negara == "Indonesia" ]]; then
            date +"%d-%m-%Y %H:%M:%S"
        else
            date +"%d-%m-%Y %I:%M:%S %p"
        fi
    else
        if [[ $negara == "Indonesia" ]]; then
            read -p "Masukkan tanggal (contoh: 10-04-2025 14:30:00): " tgl
        else
            read -p "Masukkan tarikh (contoh: 10-04-2025 02:30:00 PM): " tgl
        fi
        echo "$tgl"
    fi
}

install_kebutuhan() {
    echo -e "\e[1;33m[INFO] Mengecek kebutuhan...\e[0m"
    sleep 1

    if command -v pkg &> /dev/null; then
        echo "📱 Menginstall di Termux..."
        pkg update -y
        pkg install nano -y
        pkg install bc -y
    elif command -v apt &> /dev/null; then
        echo "🐧 Menginstall di Linux..."
        sudo apt update
        sudo apt install nano bc -y
    else
        echo -e "\e[1;31m[ERROR] Package manager tidak dikenali\e[0m"
    fi

    echo -e "\e[1;32m[SUCCESS] Semua kebutuhan terinstall!\e[0m"
    sleep 2
}

# ==================== UTANG KANTIN ====================
catat_utang() {
    clear
    logo
    echo -e "\e[1;36m========== CATAT UTANG KANTIN ==========\e[0m"
    echo -e "\e[1;34mNegara: $negara | Mata uang: $mata_uang\e[0m"
    echo ""

    echo -e "\e[1;33mPilih jenis tanggal:\e[0m"
    echo "1. Otomatis (hari ini)"
    echo "2. Manual (input sendiri)"
    read -p "Pilih [1/2]: " tgl_choice

    tanggal=$(get_tanggal $tgl_choice)

    echo ""
    read -p "Nama pemberi utang (orang yang ngasih hutang): " pemberi
    read -p "Nama penghutang (orang yang berutang): " penghutang
    read -p "Nama makanan/minuman: " item
    read -p "Jumlah ($mata_uang): " jumlah
    read -p "Dicatat oleh: " pencatat

    echo "$negara | $tanggal | Pemberi: $pemberi | Penghutang: $penghutang | $item | $mata_uang $jumlah | Dicatat: $pencatat" >> "$DATA_FILE"
    echo ""
    echo -e "\e[1;32m✓ Utang berjaya dicatat!\e[0m"
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

lihat_catatan() {
    clear
    logo
    echo -e "\e[1;36m========== DAFTAR UTANG KANTIN ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_FILE" ]] || [[ ! -s "$DATA_FILE" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang.\e[0m"
    else
        echo -e "\e[1;33mNo | Negara | Tanggal | Pemberi Utang | Penghutang | Item | Jumlah | Pencatat\e[0m"
        echo "--------------------------------------------------------------------------------------------------------"
        nl -w2 -s' | ' "$DATA_FILE"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

# ==================== UTANG ROKOK ====================
pilih_merek_rokok() {
    echo ""
    echo -e "\e[1;33m========== DAFTAR MEREK ROKOK ==========\e[0m"
    
    if [[ $negara == "Indonesia" ]]; then
        echo -e "\e[1;36mMerek Rokok Indonesia:\e[0m"
        echo "1. Surya"
        echo "2. Dji Sam Soe"
        echo "3. Marlboro"
        echo "4. Dunhill"
        echo "5. LA Lights"
        echo "6. Gudang Garam"
        echo "7. Sampoerna"
        echo "8. Esse"
        echo "9. Lainnya (input manual)"
    else
        echo -e "\e[1;36mMerek Rokok Malaysia:\e[0m"
        echo "1. Canyon"
        echo "2. Jon King"
        echo "3. Dunhill"
        echo "4. Marlboro"
        echo "5. Peter Stuyvesant"
        echo "6. Rothmans"
        echo "7. Pall Mall"
        echo "8. Lainnya (input manual)"
    fi
    
    echo ""
    read -p "Pilih merek [1-9]: " pilih_merek
    
    case $pilih_merek in
        1) 
            if [[ $negara == "Indonesia" ]]; then
                echo "Surya"
            else
                echo "Canyon"
            fi
            ;;
        2)
            if [[ $negara == "Indonesia" ]]; then
                echo "Dji Sam Soe"
            else
                echo "Jon King"
            fi
            ;;
        3) echo "Dunhill" ;;
        4) 
            if [[ $negara == "Indonesia" ]]; then
                echo "LA Lights"
            else
                echo "Marlboro"
            fi
            ;;
        5)
            if [[ $negara == "Indonesia" ]]; then
                echo "Gudang Garam"
            else
                echo "Peter Stuyvesant"
            fi
            ;;
        6)
            if [[ $negara == "Indonesia" ]]; then
                echo "Sampoerna"
            else
                echo "Rothmans"
            fi
            ;;
        7)
            if [[ $negara == "Indonesia" ]]; then
                echo "Esse"
            else
                echo "Pall Mall"
            fi
            ;;
        8) 
            read -p "Masukkan merek rokok: " merek_manual
            echo "$merek_manual"
            ;;
        *)
            read -p "Masukkan merek rokok: " merek_manual
            echo "$merek_manual"
            ;;
    esac
}

catat_utang_rokok() {
    clear
    logo
    echo -e "\e[1;36m========== CATAT UTANG ROKOK (PER SELOP) ==========\e[0m"
    echo -e "\e[1;34mNegara: $negara | Mata uang: $mata_uang\e[0m"
    echo ""
    echo -e "\e[1;33mKeterangan:\e[0m"
    echo "1 selop = 10 bungkus rokok"
    echo ""

    echo -e "\e[1;33mPilih jenis tanggal:\e[0m"
    echo "1. Otomatis (hari ini)"
    echo "2. Manual (input sendiri)"
    read -p "Pilih [1/2]: " tgl_choice

    tanggal=$(get_tanggal $tgl_choice)

    # Pilih merek rokok
    merk=$(pilih_merek_rokok)
    
    echo ""
    read -p "Nama pemberi utang (orang yang ngasih rokok/hutang): " pemberi
    read -p "Nama penghutang (orang yang berutang rokok): " penghutang
    read -p "Jumlah selop: " selop
    read -p "Harga per selop ($mata_uang): " harga_per_selop
    read -p "Dicatat oleh: " pencatat

    # Hitung total
    total=$(echo "$selop * $harga_per_selop" | bc)

    echo ""
    echo -e "\e[1;32m✓ Rincian utang rokok:\e[0m"
    echo "   Merek Rokok    : $merk"
    echo "   Pemberi Utang  : $pemberi"
    echo "   Penghutang     : $penghutang"
    echo "   Jumlah         : $selop selop"
    echo "   Harga/selop    : $mata_uang $harga_per_selop"
    echo "   TOTAL UTANG    : $mata_uang $total"
    echo ""

    # Simpan ke file
    echo "$negara | $tanggal | Rokok: $merk | Pemberi: $pemberi | Penghutang: $penghutang | $selop selop x $mata_uang $harga_per_selop = $mata_uang $total | Dicatat: $pencatat" >> "$DATA_ROKOK"

    echo -e "\e[1;32m✓ Utang rokok berhasil dicatat!\e[0m"
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

lihat_utang_rokok() {
    clear
    logo
    echo -e "\e[1;36m========== DAFTAR UTANG ROKOK ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_ROKOK" ]] || [[ ! -s "$DATA_ROKOK" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang rokok.\e[0m"
    else
        echo -e "\e[1;33mNo | Negara | Tanggal | Merek | Pemberi | Penghutang | Jumlah & Total | Pencatat\e[0m"
        echo "--------------------------------------------------------------------------------------------------------"
        nl -w2 -s' | ' "$DATA_ROKOK"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

# ==================== HAPUS ====================
hapus_catatan_kantin() {
    clear
    logo
    echo -e "\e[1;36m========== HAPUS CATATAN UTANG KANTIN ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_FILE" ]] || [[ ! -s "$DATA_FILE" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang kantin.\e[0m"
        echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
        read
        return
    fi

    echo -e "\e[1;33mDaftar catatan utang kantin:\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    nl -w2 -s' | ' "$DATA_FILE"
    echo "--------------------------------------------------------------------------------------------------------"
    echo ""

    read -p "Masukkan nomor catatan yang ingin dihapus (atau 0 untuk batal): " nomor

    if [[ $nomor -eq 0 ]]; then
        echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
        sleep 1
        return
    fi

    total_baris=$(cat "$DATA_FILE" | wc -l)

    if [[ $nomor -ge 1 ]] && [[ $nomor -le $total_baris ]]; then
        data_hapus=$(sed -n "${nomor}p" "$DATA_FILE")
        echo ""
        echo -e "\e[1;33mData yang akan dihapus:\e[0m"
        echo -e "\e[1;31m$data_hapus\e[0m"
        echo ""
        read -p "Yakin ingin menghapus? (y/n): " konfirmasi

        if [[ $konfirmasi == "y" ]] || [[ $konfirmasi == "Y" ]]; then
            sed -i "${nomor}d" "$DATA_FILE"
            echo -e "\e[1;32m✓ Catatan berhasil dihapus!\e[0m"
        else
            echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
        fi
    else
        echo -e "\e[1;31mNomor tidak valid!\e[0m"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

hapus_semua_kantin() {
    clear
    logo
    echo -e "\e[1;36m========== HAPUS SEMUA UTANG KANTIN ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_FILE" ]] || [[ ! -s "$DATA_FILE" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang kantin.\e[0m"
        echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
        read
        return
    fi

    echo -e "\e[1;31m⚠️ PERINGATAN! ⚠️\e[0m"
    echo -e "\e[1;33mAnda akan menghapus SEMUA catatan utang kantin.\e[0m"
    echo ""
    read -p "Yakin ingin menghapus semua? (y/n): " konfirmasi

    if [[ $konfirmasi == "y" ]] || [[ $konfirmasi == "Y" ]]; then
        > "$DATA_FILE"
        echo -e "\e[1;32m✓ Semua catatan utang kantin berhasil dihapus!\e[0m"
    else
        echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

hapus_utang_rokok() {
    clear
    logo
    echo -e "\e[1;36m========== HAPUS UTANG ROKOK ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_ROKOK" ]] || [[ ! -s "$DATA_ROKOK" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang rokok.\e[0m"
        echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
        read
        return
    fi

    echo -e "\e[1;33mDaftar utang rokok saat ini:\e[0m"
    echo "--------------------------------------------------------------------------------------------------------"
    nl -w2 -s' | ' "$DATA_ROKOK"
    echo "--------------------------------------------------------------------------------------------------------"
    echo ""

    read -p "Masukkan nomor catatan yang ingin dihapus (atau 0 untuk batal): " nomor

    if [[ $nomor -eq 0 ]]; then
        echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
        sleep 1
        return
    fi

    total_baris=$(cat "$DATA_ROKOK" | wc -l)

    if [[ $nomor -ge 1 ]] && [[ $nomor -le $total_baris ]]; then
        data_hapus=$(sed -n "${nomor}p" "$DATA_ROKOK")
        echo ""
        echo -e "\e[1;33mData yang akan dihapus:\e[0m"
        echo -e "\e[1;31m$data_hapus\e[0m"
        echo ""
        read -p "Yakin ingin menghapus? (y/n): " konfirmasi

        if [[ $konfirmasi == "y" ]] || [[ $konfirmasi == "Y" ]]; then
            sed -i "${nomor}d" "$DATA_ROKOK"
            echo -e "\e[1;32m✓ Catatan utang rokok berhasil dihapus!\e[0m"
        else
            echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
        fi
    else
        echo -e "\e[1;31mNomor tidak valid!\e[0m"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

hapus_semua_rokok() {
    clear
    logo
    echo -e "\e[1;36m========== HAPUS SEMUA UTANG ROKOK ==========\e[0m"
    echo ""

    if [[ ! -f "$DATA_ROKOK" ]] || [[ ! -s "$DATA_ROKOK" ]]; then
        echo -e "\e[1;31mBelum ada catatan utang rokok.\e[0m"
        echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
        read
        return
    fi

    echo -e "\e[1;31m⚠️ PERINGATAN! ⚠️\e[0m"
    echo -e "\e[1;33mAnda akan menghapus SEMUA catatan utang rokok.\e[0m"
    echo ""
    read -p "Yakin ingin menghapus semua? (y/n): " konfirmasi

    if [[ $konfirmasi == "y" ]] || [[ $konfirmasi == "Y" ]]; then
        > "$DATA_ROKOK"
        echo -e "\e[1;32m✓ Semua catatan utang rokok berhasil dihapus!\e[0m"
    else
        echo -e "\e[1;34mPenghapusan dibatalkan.\e[0m"
    fi

    echo ""
    echo -e "\e[1;34mTekan enter untuk kembali...\e[0m"
    read
}

# ==================== MAIN MENU ====================
pilih_negara

while true; do
    clear
    logo
    echo -e "\e[1;35m========== MENU UTAMA ==========\e[0m"
    echo -e "\e[1;34mNegara aktif: $negara ($mata_uang)\e[0m"
    echo ""
    echo "┌──────────────────────────────────────────┐"
    echo "│  🍽️  UTANG KANTIN                        │"
    echo "├──────────────────────────────────────────┤"
    echo "│ 1. 📝 Catat utang kantin                 │"
    echo "│ 2. 📋 Lihat utang kantin                 │"
    echo "│ 3. 🗑️  Hapus utang kantin                 │"
    echo "├──────────────────────────────────────────┤"
    echo "│  🚬  UTANG ROKOK                          │"
    echo "├──────────────────────────────────────────┤"
    echo "│ 4. 🚬 Catat utang rokok (per selop)      │"
    echo "│ 5. 📋 Lihat utang rokok                  │"
    echo "│ 6. 🗑️  Hapus utang rokok                  │"
    echo "├──────────────────────────────────────────┤"
    echo "│  ⚙️  LAINNYA                              │"
    echo "├──────────────────────────────────────────┤"
    echo "│ 7. ⚙️  Install kebutuhan                  │"
    echo "│ 8. 🌍 Ganti negara                       │"
    echo "│ 9. 🚪 Exit                               │"
    echo "└──────────────────────────────────────────┘"
    echo ""
    read -p "Pilih menu [1-9]: " menu

    case $menu in
        1) catat_utang ;;
        2) lihat_catatan ;;
        3)
            clear
            logo
            echo -e "\e[1;35m========== HAPUS UTANG KANTIN ==========\e[0m"
            echo "1. Hapus satu catatan"
            echo "2. Hapus semua catatan"
            echo "3. Kembali"
            echo ""
            read -p "Pilih [1-3]: " sub
            case $sub in
                1) hapus_catatan_kantin ;;
                2) hapus_semua_kantin ;;
                *) continue ;;
            esac
            ;;
        4) catat_utang_rokok ;;
        5) lihat_utang_rokok ;;
        6)
            clear
            logo
            echo -e "\e[1;35m========== HAPUS UTANG ROKOK ==========\e[0m"
            echo "1. Hapus satu catatan rokok"
            echo "2. Hapus semua catatan rokok"
            echo "3. Kembali"
            echo ""
            read -p "Pilih [1-3]: " sub
            case $sub in
                1) hapus_utang_rokok ;;
                2) hapus_semua_rokok ;;
                *) continue ;;
            esac
            ;;
        7) install_kebutuhan ;;
        8) pilih_negara ;;
        9)
            echo -e "\e[1;32mTerima kasih! Thank you! ~ Laksamana\e[0m"
            exit 0
            ;;
        *)
            echo -e "\e[1;31mPilihan salah! Tekan enter...\e[0m"
            read
            ;;
    esac
done
