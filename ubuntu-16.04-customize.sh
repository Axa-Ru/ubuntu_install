#!/bin/bash

################################################################## 
OS="Ubuntu 16.04"
SCR_VER="16.04-2017-06-09"

#set -e

C_NRM="\e[0m"
C_RED="\e[1;49;91m"
C_GRN="\e[1;49;32m"
C_YEL="\e[1;49;33m"
C_BLU="\e[1;49;94m"
C_CYA="\e[1;49;96m"

## проверьте имя USER. Оно подставится при установке nfs, qemu-kvn
USER="axa"
GROUP="axa"
DEBUG=0

# Установим автоматический режим
AUTO="Y"
LOGF="ubuntu_install.log"

# Загружаем значения об уже выполнишехся установках
# Если нужно выполнить установку сначала - просто удалите файл $LOGF
if [ -f $LOGF ]; then 
    source $LOGF
fi

# Выбор пакетов, которые будут установлены автоматически
AUTO_DUNNY="N"
AUTO_AVAHI="Y"
AUTO_I915FW="Y"
AUTO_BROTHER_MFC7840W="Y"
AUTO_HPLIP="Y"
AUTO_FILE_UTILS="Y"
AUTO_SOLAR="N"
AUTO_GNOME_FONTMANAGER="Y"
AUTO_GXNEUR="N"
AUTO_NFS_CLIENT="Y"
AUTO_COMPIZ="Y"
AUTO_TWEAK="Y"
AUTO_QUEMU_KVM="N"
AUTO_ORACLE_JAVA="Y"
AUTO_NOTIFY_OSF="Y"
AUTO_THEMES_AND_ICON="Y"
AUTO_DIODON_CLIPBOARD_MANAGER="Y"
AUTO_STICKYNOTES_INDICATOR="Y"
AUTO_REDNOTEBOOK_INDICATOR="Y"
AUTO_GNOME3="N"
AUTO_OWNCLOUD_CLIENT="Y"
AUTO_NULTIMEDIA="Y"
AUTO_AUDACIOS="Y"
AUTO_COMMON_DEV_TOOLS="Y"
AUTO_PYTHON36="N"
AUTO_QT_PYQT="Y"
AUTO_YAD="Y"
AUTO_BOOKREADERS="Y"
AUTO_FB2EDIT="N"
AUTO_SONY_PRS505="N"
AUTO_LIBREOFFICE="Y"
AUTO_RUSSIAN_DIC="Y"
AUTO_GOLDENDICT="Y"
AUTO_KEEPASSX="Y"
AUTO_GNUCASH="Y"
AUTO_GRAPHIC_TOOLS="Y"
AUTO_SKYPE="N"
AUTO_TELEGRAM="Y"
AUTO_TRANSGUI="Y"
AUTO_WEATHER_WIDGET="Y"
AUTO_KICAD="Y"
AUTO_STLINKV2_GUI="Y"
AUTO_OPENSTM32="Y"
AUTO_CROSSWORKS="N"
AUTO_SEGGER="Y"
AUTO_FRITZING="N"

# --------------------------------------------------------------
# $1       "Y" Пакет устанавливать в автоматическом режиме
#          "N" Пакет не устанавливать в автоматическом режиме
# $2       1  Если пакет уже установлен 
# $3 - $21 Строки которые будут отображаться
answer ()
{
    echo -e "\n\n${C_CYA} $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${C_NRM}"
    for(( DONE=0; DONE==0;  ))
    do
        if [ $AUTO == "Y" ]; then     # Автоматический режим
            if [ $1 == "Y" -a -z "$2" ]; then    # Пакет устанваливаем
                ANS=Y
            else
                echo "Пропускаем ..."
                ANS=S
            fi
            DONE=1
        else                          # Ручной режим
            read -p "Continue ? (Y)es, (A)bort, (S)kip : " VAL
            VAL=${VAL:0:1}
            case $VAL in
              [Y,y])
                ANS="Y"
                DONE=1
                ;;
              [A,a])
                echo -e "${C_YEL}Bye-Bye${C_NRM}"
                exit 1
                ;;
              [S,s])
                ANS="S"
                DONE=1
                ;;
              *)
                echo -e "${C_YEL}No! No! No! You must type 'Y', 'A' or 'S'${C_NRM}"
                ;;
            esac
        fi
    done
}


# --------------------------------------------------------------
# Начало скрипта
if [ -n "$1" ]; then
    VAL=$1
    VAL=${VAL:0:1}
    if [ $VAL = "A" ]; then AUTO="Y"; fi
fi

answer "" \
       "" \
       "===========================================================\n" \
       " Скрипт установки и настройки ${C_YEL}${OS}${C_CYA} \n" \
       " Версия:   ${C_YEL}${SCR_VER}${C_CYA} \n\n" \
       " Использование:\n" \
       "    ${C_YEL}${0}${C_CYA} - интерактивная установка. \n" \
       "          На каждый блок устанавливаемых программ\n" \
       "          будет запрашиваться подтверждение\n" \
       "    ${C_YEL}${0} AUTO${C_CYA} - автоматическая,\n" \
       "          пакетная установка (не реализовано)\n" \
       "\n" \
       " Скрипт нужно запускать из под рута:  ${C_YEL}sudo -i${C_CYA}\n" \
       "\n" \
       " Перед запуском этого скрипта выполните обновление системы\n" \
       "   sudo apt update && sudo apt dist-upgrade\n" \
       "==========================================================="

# --------------------------------------------------------------
#  Проверка на то, что мы запускаем под root
#   sudo -i 
USR=`whoami`
if [ "$USR" != "root" ]; then
    echo "Run $0 as Superuser"
    exit 1
fi

answer "$AUTO_DUMMY" \
       "$DONE_DUMMY" \
       "+-----------------------------------------------------------------------------+\n" \
       "|   Шаблон установочного пакета                                               |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;

    # 	Здесь разместите команды установки пекета

    popd; echo "DONE_DUMMY=1" >> $LOGF
fi


answer "$AUTO_AVAHI" \
       "$DONE_AVAHI" \
       "+-----------------------------------------------------------------------------+\n" \
       "|   Выключенить отправку отчета об ошибках, Avahi                             |\n" \
       "|   Отключенить сервис Avahi                                                  |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;

    sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
    service apport stop
    sed -i 's/AVAHI_DAEMON_DETECT_LOCAL=1/AVAHI_DAEMON_DETECT_LOCAL=0/g' /etc/default/avahi-daemon

    popd; echo "DONE_AVAHI=1" >> $LOGF
fi

answer "$AUTO_I915FW" \
       "$DONE_I915FW" \
       "+-----------------------------------------------------------------------------+\n" \
       "| В Ubuntu 16.04 присутствует баг, проявляющийся в виде моргания экрана       |\n" \
       "| Установка firmware от Intel устраняет этот баг.                             |\n" \
       "|                                                                             |\n" \
       "|   Установить firmware для i915 ?                                            |\n" \
       "|   Установить параметры для работы драйвера ?                                |\n" \
       "|  options i915 enable_rc6=7 enable_psr=2                                     |\n" \
       "|      enable_fbc=1 lvds_downclock=1 semaphores=1                             |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;

    wget https://download.01.org/gfx/ubuntu/16.04/main/pool/main/i/intel-graphics-update-tool/intel-graphics-update-tool_2.0.2_amd64.deb
    dpkg --install intel-graphics-update-tool_2.0.2_amd64.deb
    intel-graphics-update-tool

    popd; echo "DONE_I915FW=1" >> $LOGF
fi

answer "$AUTO_BROTHER_MFC7840W" \
       "$DONE_BROTHER_MFC7840W" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Устанавливаем Brother MFC-7840wr System setting->Printers                   |\n" \
       "|   после - сканер, основано на инструкции                                    |\n" \
       "+-----------------------------------------------------------------------------+\n"
# http://askubuntu.com/questions/791556/not-working-brother-scanner-in-ubuntu-16-04-though-driver-installed
if [ $ANS = "Y" ]; then pushd /tmp;

    wget http://www.brother.com/pub/bsc/linux/dlf/brscan3-0.2.11-5.amd64.deb \
         http://www.brother.com/pub/bsc/linux/dlf/brscan-skey-0.2.4-1.amd64.deb
    brsaneconfig3 -a name=SCANER-MFC-7840W model=MFC-7840W ip=192.168.56.70
    mkdir /usr/lib/sane
    ln -s /usr/lib64/sane/libsane-brother3.so /usr/lib/sane/libsane-brother3.so
    ln -s /usr/lib64/sane/libsane-brother3.so.1 /usr/lib/sane/libsane-brother3.so.1
    ln -s /usr/lib64/sane/libsane-brother3.so.1.0.7 /usr/lib/sane/libsane-brother3.so.1.0.7
    ln -s /usr/lib64/libbrscandec3.so /usr/lib/libbrscandec3.so
    ln -s /usr/lib64/libbrscandec3.so.1 /usr/lib/libbrscandec3.so.1
    ln -s /usr/lib64/libbrscandec3.so.1.0.0 /usr/lib/libbrscandec3.so.1.0.0

    popd; echo "DONE_BROTHER_MFC7840W=1" >> $LOGF
fi

answer "$AUTO_HPLIP" \
       "$DONE_HPLIP" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Устанавливаем HPLiP ?                                                       |\n" \
       "|     sudo -u axa sh hplip-3.16.10.run                                        |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;

    wget http://vorboss.dl.sourceforge.net/project/hplip/hplip/3.16.10/hplip-3.16.10.run
    chmod +x hplip-3.16.10.run
    sudo -u $USER sh hplip-3.16.10.run

    popd; echo "DONE_HPLIP=1" >> $LOGF
fi

answer "$AUTO_FILE_UTILS" \
       "$DONE_FILE_UTILS" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Last version of:                                                            |\n" \
       "|   midnight commander                                                        |\n" \
       "|   Double commander                                                          |\n" \
       "|   Krusader                                                                  |\n" \
       "| Archivers:                                                                  |\n" \
       "|   p7zip-full p7zip-rar unace rar unrar zip unzip                            |\n" \
       "|   sharutils uudeview mpack arj cabextract                                   |\n" \
       "|   file-roller                                                               |\n" \
       "| Utilities:                                                                  |\n" \
       "|   htop powertop gparted ssh exFat driver                                    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:eugenesan/ppa && apt update
    apt install -y mc
    add-apt-repository -y ppa:alexx2000/doublecmd && apt update 
    apt install -y doublecmd-gtk krusader
    apt install -y p7zip-full p7zip-rar unace unrar zip unzip sharutils \
                   uudeview mpack arj cabextract file-roller rar htop powertop \
                   gparted ssh exfat-fuse exfat-utils
    # Add start powertop whithout password
    sed -i '/# User privilege specification/a axa     ALL=(root) /usr/sbin/powertop' /etc/sudoers
    popd; echo "DONE_FILE_UTILS=1" >> $LOGF
fi

answer "$AUTO_SOLAR" \
       "$DONE_SOLAR" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Solaar - Logtech radio mice tool                                           |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y solaar

    popd; echo "DONE_SOLAR=1" >> $LOGF
fi

answer "$AUTO_GNOME_FONTMANAGER" \
       "$DONE_GNOME_FONTMANAGER" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Gnome font manager                                                          |\n" \
       "| Устанавливить из репозитория разработчика:                                  |\n" \
       "|   ppa:font-manager/staging  ?                                               |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:font-manager/staging && apt-get update
    apt install -y font-manager

    popd; echo "DONE_GNOME_FONTMANAGER=1" >> $LOGF
fi          


answer "$AUTO_GXNEUR" \
       "$DONE_GXNEUR" \
       "+-----------------------------------------------------------------------------+\n" \
       "| gXneur                                                                      |\n" \
       "|   http://sysadm.pp.ua/linux/nfs-and-autofs.html                             |\n" \
       "| Buggy in 14.04                                                              |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:andrew-crew-kuznetsov/xneur-unstable && apt update
    apt install -y xneur gxneur
  # Ubuntu 13.04 not supported
    #gsettings set com.canonical.Unity.Panel systray-whitelist "['all']" 

    popd; echo "DONE_GXNEUR=1" >> $LOGF
fi


answer "$AUTO_NFS_CLIENT" \
       "$DONE_NFS_CLIENT" \
       "+-----------------------------------------------------------------------------+\n" \
       "| nfs client and autonfs                                                      |\n" \
       "|   http://sysadm.pp.ua/linux/nfs-and-autofs.html                             |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    
    apt install -y nfs-common
    apt install -y autofs
    sh -c 'echo "/nfs /etc/auto.nfs --timeout=60" >> /etc/auto.master'
    sh -c 'echo "nas4d0     -rw,soft,intr,rsize=8192,wsize=8192     192.168.56.66:/raid0/data/_NAS_NFS_Exports_/Nas4d0" >> /etc/auto.nfs'
    sh -c 'echo "srv1d0     -rw,soft,intr,rsize=8192,wsize=8192     192.168.56.67:/home/axa" >> /etc/auto.nfs'
    /etc/init.d/autofs restart
    mkdir /home/${USER}/Media
    chown ${USER}:${USER} /home/${USER}/Media
    cd /home/${USER}/Media
    ln -s /nfs/nas4d0 .
    ln -s /nfs/srv1d0 .
    ln -s /media/axa .
    
    popd; echo "DONE_NFS_CLIENT=1" >> $LOGF
fi

answer "$AUTO_COMPIZ" \
       "$DONE_COMPIZ" \
       "+-----------------------------------------------------------------------------+\n" \
       "| compiz, ccsm                                                                |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y compiz compizconfig-settings-manager compiz-plugins-extra

    popd; echo "DONE_COMPIZ=1" >> $LOGF
fi

answer "$AUTO_TWEAK" \
       "$DONE_TWEAK" \
       "+-----------------------------------------------------------------------------+\n" \
       "| ubuntu-tweak, Unity Tweak Tool, Gnome Tweak Tool, dconf-editor, synaptic    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    wget http://archive.getdeb.net/ubuntu/pool/apps/u/ubuntu-tweak/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
    dpkg -i ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
    apt install -f
    apt install -y unity-tweak-tool gnome-tweak-tool dconf-editor synaptic

    popd; echo "DONE_TWEAK=1" >> $LOGF
fi

answer "$AUTO_QUEMU_KVM" \
       "$DONE_QUEMU_KVM" \
       "+-----------------------------------------------------------------------------+\n" \
       "| qemu-kvm                                                                    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    # Processor test
    VIRT=$(egrep -c '(vmx|svm)' /proc/cpuinfo)
    if [ $VIRT -eq 0 ]; then
        apt install qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils virt-manager virt-viewer cpu-checker
        adduser $USER libvirtd
        echo "http://itman.in/kvm-hypervisor-setup/"
        echo "https://losst.ru/ustanovka-kvm-ubuntu-16-04"
    else
        echo "kvm not supportet bu CPU"
    fi

    popd; echo "DONE_QUEMU_KVM=1" >> $LOGF
fi


answer "$AUTO_ORACLE_JAVA" \
       "$AUTO_ORACLE_JAVA" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Устанавливаем Oracle Java(TM) SE Runtime Environment                        |\n" \
       "| http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:webupd8team/java && apt update
    apt install -y oracle-java8-installer

    popd; echo "DONE_ORACLE_JAVA=1" >> $LOGF
fi

answer "$AUTO_NOTIFY_OSD" \
       "$DONE_NOTIFY_OSD" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  notify-osd                                                                 |\n" \
       "|     http://www.webupd8.org/2011/05/configurable-notifyosd-bubbles-for.html  |\n" \
       "|     https://launchpad.net/~leolik/+archive/ubuntu/leolik                    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:leolik/leolik && apt update && apt upgrade
    apt install -y libnotify-bin
    add-apt-repository -y ppa:nilarimogard/webupd8 && apt update && apt upgrade
    apt install -y notifyosdconfig

    popd; echo "DONE_NOTIFY_OSD=1" >> $LOGF
fi

answer "$AUTO_THEMES_AND_ICON" \
       "$DONE_THEMES_AND_ICON" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Themes and Icons:                                                           |\n" \
       "| http://www.noobslab.com/2016/03/vivacious-colors-gtk-theme-suite.html       |\n" \
       "| http://www.noobslab.com/2013/                                               |\n" \
       "|     07/nouvegnome-color-and-gray-icon-sets-for.html                         |\n" \
       "|                                                                             |\n" \
       "| Use Ubuntu Tweak after                                                      |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:ravefinity-project/ppa && sudo apt update
    apt install -y vivacious-colors-gtk-dark \
                         vivacious-colors-gtk-light \
                         vivacious-unity-gtk-dark \
                         vivacious-unity-gtk-light
    add-apt-repository -y ppa:noobslab/icons && apt-get update
    apt install -y nouvegnome-gray

    opod; echo "DONE_THEMES_AND_ICON=1" >> $LOGF
fi

answer "$AUTO_DIODON_CLIPBOARD_MANAGER" \
       "$DONE_DIODON_CLIPBOARD_MANAGER" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Diodon Clipboard Manager                                                   |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y diodon

    popd; echo "DONE_DIODON_CLIPBOARD_MANAGER=1" >> $LOGF
fi

answer "$AUTO_STICKYNOTES_INDICATOR" \
       "$DONE_STICKYNOTES_INDICATOR" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  stickynotes Indicator                                                      |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:umang/indicator-stickynotes && apt update
    apt install -y indicator-stickynotes

    popd; echo "DONE_STICKYNOTES_INDICATOR=1" >> $LOGF
fi

answer "$AUTO_REDNOTEBOOK_INDICATOR" \
       "$DONE_REDNOTEBOOK_INDICATOR" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  rednotebook Indicator                                                      |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:rednotebook/daily && sudo apt update
    apt install -y rednotebook

    popd; echo "DONE_REDNOTEBOOK_INDICATOR=1" >> $LOGF
fi

answer "$AUTO_GNOME3" \
       "$DONE_GNOME3" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Gnome 3                                                                     |\n" \
       "| http://www.omgubuntu.co.uk/2016/05/                                         |\n" \
       "|              install-gnome-3-20-ubuntu-16-04-lts                            |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:gnome3-team/gnome3-staging
    add-apt-repository -y ppa:gnome3-team/gnome3fi
    apt update
    apt dist-upgrade -y
    apt install -y gnome gnome-shell

    popd; echo "DONE_GNOME3=1" >> $LOGF
fi

answer "$AUTO_OWNCLOUD_CLIENT" \
       "$DONE_OWNCLOUD_CLIENT" \
       "+-----------------------------------------------------------------------------+\n" \
       "| OwnCloud Desktop Client                                                     |\n" \
       "| https://software.opensuse.org/download/                                     |\n" \
       "|   package?project=isv:ownCloud:desktop&package=owncloud-client              |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    
    wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key
    sudo apt-key add - < Release.key
    sudo apt-get update
    apt install -y owncloud-client

    popd; echo "DONE_OWNCLOUD_CLIENT=1" >> $LOGF
fi


# --------------------------------------------------------------
#   Audio
answer "$AUTO_MULTIMEDIA" \
       "$DONE_MULTIMEDIA" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Audio multimedia codecs                                                    |\n" \
       "|  command line player, ogg vorbis tools                                      |\n" \
       "|  Tags editor and GUI player                                                 |\n" \
       "|  vlc browser-plugin-vlc                                                     |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y ubuntu-restricted-extras ffmpeg gxine \
                   libdvdread4 icedax tagtool libdvd-pkg \
                   easytag id3tool tagtool lame libxine2-ffmpeg \
                   id3v2 flac libav-tools mp3splt wavpack \
                   sox nautilus-script-audio-convert \
                   libmad0 mpg321 libavcodec-extra gstreamer1.0-libav \
                   libsox-fmt-mp3 vorbis-tools audacity \
                   mencoder alac-decoder vlc browser-plugin-vlc
    

    wget https://od.lk/d/56708443_kKKU9/mac-3.99-u4_3.99-4.5_amd64.deb
    dpkg --install mac-3.99-u4_3.99-4.5_amd64.deb
    
    popd; echo "DONE_MULTIMEDIA=1" >> $LOGF
fi

answer "$AUTO_AUDACIOS" \
       "$DONE_AUDACIOS" \
       "+-----------------------------------------------------------------------------+\n" \
       "| audacious 3.5                                                               |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:nilarimogard/webupd8 && apt update
    apt install -y audacious

    popd; echo "DONE_AUDACIOS=1" >> $LOGF
fi


# --------------------------------------------------------------
#    Development tools

answer "$AUTO_COMMON_DEV_TOOLS" \
       "$DONE_COMMON_DEV_TOOLS" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Install common Development tools                                            |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y g++ md5deep fakeroot geany geany-plugins cmake bless

    popd; echo "DONE_COMMON_DEV_TOOLS=1" >> $LOGF
fi

answer "$AUTO_PYTHON36" \
       "$DONE_PYTHON36" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Install python3.6,                                                          |\n" \
       "|   PyCharm 2016.3.2                                                          |\n" \
       "|    http://www.360kb.com/kb/2_24.html                                        |\n" \
       "|    Build #PY-163.10154.50, built on December 28, 2016                       |\n" \
       "|    Licensed to lan yu                                                       |\n" \
       "|    Subscription is active until November 23, 2017                           |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:fkrull/deadsnakes && apt update
    apt install python3.6 python3-setuptools
    easy_install3 -y pip
    add-apt-repository -y ppa:mystic-mirage/pycharm && apt update
    apt install -y pycharm

    popd; echo "DONE_PYTHON36=1" >> $LOGF
fi

answer "$AUTO_QT_PYQT" \
       "$DONE_QT_PYQT" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Qt 5.7 и PyQt                                                               |\n" \
       "+-----------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then pushd /tmp;
    
    wget http://download.qt-project.org/official_releases/qt/5.7/5.7.0/qt-opensource-linux-x64-5.7.0.run
    chmod +x qt-opensource-linux-x64-5.7.0.run
    ./qt-opensource-linux-x64-5.7.0.run
    apt install -y build-essential python3-dev python3-pyqt5 pyqt5-dev-tools
    pip3 install SIP
    
    popd; echo "DONE_QT_PYQT=1" >> $LOGF
fi

answer "$AUTO_YAD" \
       "$DONE_YAD" \
       "+-----------------------------------------------------------------------------+\n" \
       "| YAD форк Zenity                                                             |\n" \
       "|-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:webupd8team/y-ppa-manager && apt update
    apt install -y yad

    popd; echo "DONE_YAD=1" >> $LOGF
fi

echo -e "Устанавливаем Android Studio\n https://developer.android.com/studio/index.html\n"

# --------------------------------------------------------------
#    Приложения

answer "$AUTO_BOOKREADERS" \
       "$DONE_BOOKREADERS" \
       "+-----------------------------------------------------------------------------+\n" \
       "| coolreader, fbreader                                                        |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    #add-apt-repository -y ppa:vovansrnd/coolreader && apt update
    #apt install cr3
    # Сборки под 16.04 пока нет.
    
    wget http://ppa.launchpad.net/vovansrnd/coolreader/ubuntu/pool/main/c/cr3/cr3_3.1.2.3-39_amd64.deb
    sudo dpkg --install cr3_3.1.2.3-39_amd64.deb
    apt install -f
    wget http://dl.dropbox.com/u/22272434/src/cr3.ini -O ~/.cr3/cr3.ini
    ln -s /usr/share/cr3/backgrounds/ ~/.cr3/backgrounds
    apt install -y fbreader

    popd; echo "DONE_BOOKREADERS=1" >> $LOGF
fi

answer "$AUTO_FB2EDIT" \
       "$DONE_FB2EDIT" \
       "+-----------------------------------------------------------------------------+\n" \
       "| http://fb2edit.lintest.ru/                                                  |\n" \
       "| http://linuxmasterclub.ru/fb2edit/                                          |\n" \
       "|                                                                             |\n" \
       "| http://ubuntuhandbook.org/index.php/2016/06/sigil-0-9-6-ppa-ubuntu-16-04/   |\n" \
       "| https://github.com/Sigil-Ebook/Sigil                                        |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    # сборки для 16.04 нет. Ставим сборку от 14.04
    #add-apt-repository -y ppa:lintest/fb2edit
    #apt update && apt install fb2edit

    wget https://launchpadlibrarian.net/180250769/fb2edit_0.0.9-utopic2_amd64.deb
    dpkg --install fb2edit_0.0.9-utopic2_amd64.deb

    add-apt-repository -y ppa:ubuntuhandbook1/sigil
    apt update && apt install -y sigil sigil-data

    popd; echo "DONE_FB2EDIT=1" >> $LOGF
fi

answer "$AUTO_SONY_PRS505" \
       "$DONE_SONY_PRS505" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Sony Prs-505 sync manager                                                   |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    wget http://AxaRu.opendrive.com/files/68506444_wLMCL_a43e/mngr505
    chmod +x mngr505
    mv mngr505 /usr/bin

    popd; echo "DONE_SONY_PRS505=1" >> $LOGF
fi

answer "$AUTO_LIBREOFFICE" \
       "$DONE_LIBREOFFICE" \
       "+-----------------------------------------------------------------------------+\n" \
       "|   LibreOffice                                                               |\n" \
       "|   removing default LibreOffice and reinstall actual version                 |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then  pushd /tmp;

    # Ubuntu 16.04 Libreoffice Version: 5.1.4.2
    apt remove --purge -y libreoffice*
    apt clean -y
    apt autoremove -y
    add-apt-repository -y ppa:libreoffice/ppa && apt update
    apt install -y libreoffice libreoffice-help-ru libreoffice-l10n-ru
    # расстановка переносов
    apt install -y openoffice.org-hyphenation

    popd; echo "DONE_LIBREOFFICE=1" >> $LOGF
fi

answer "$AUTO_RUSSIAN_DIC" \
       "$DONE_RUSSIAN_DIC" \
       "+-----------------------------------------------------------------------------+\n" \
       "|   Устанавливаем Русские словари для gedit и т.п.                            |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y aspell \
                     aspell-ru \
                     language-pack-gnome-ru-base \
                     language-pack-gnome-ru \
                     language-pack-ru-base \
                     language-pack-ru \
                     thunderbird-locale-ru \
                     gimp-help-ru \
                     mueller7-dict \
                     scim-modules-table \
                     scim-tables-additional \
                     myspell-ru
    popd; echo "DONE_RUSSIAN_DIC=1" >> $LOGF
fi

answer "$AUTO_GOLDENDICT" \
       "$DONE_GOLDENDICT" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  GoldenDict                                                                 |\n" \
       "|  http://ubuntuportal.com/2013/02/goldendict-complete-dictionary-            |\n" \
       "|      app-for-ubuntu-based-distribution.html                                 |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y goldendict

    popd; echo "DONE_GOLDENDICT=1" >> $LOGF
fi

answer "$AUTO_KEEPASSX" \
       "$DONE_KEEPASSX" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  keepassx                                                                   |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y keepassx

    popd; echo "DONE_KEEPASSX=1" >> $LOGF
fi

answer "$AUTO_GNUCASH" \
       "$DONE_GNUCASH" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  gnucash                                                                    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y gnucash
    echo "DONE_GNUCASH=1" >> $LOGF
fi

answer "$AUTO_GRAPHIC_TOOLS" \
       "$DONE_GRAPHIC_TOOLS" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Graphical tools                                                            |\n" \
       "|    Gimp, shutter, inkscape, digikam, dia, master-pdf-editor                 |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    apt install -y gimp gimp-data gimp-plugin-registry gimp-data-extras \
                   shutter inkscape digikam dia calligraflow imagemagick
    wget http://get.code-industry.net/public/master-pdf-editor-4.1.30_qt5.amd64.deb
    dpkg -i master-pdf-editor-4.1.30_qt5.amd64.deb

    popd echo "DONE_GRAPHIC_TOOLS=1" >> $LOGF
fi


answer "$AUTO_SKYPE" \
       "$DONE_SKYPE" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Skype                                                                      |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
    dpkg --add-architecture i386
    apt-get update
    apt install -y skype

    popd; echo "DONE_SKYPE=1" >> $LOGF
fi

answer "$AUTO_TELEGRAM" \
       "$DONE_TELEGRAM" \
       "+-----------------------------------------------------------------------------+\n" \
       "|  Telegram                                                                   |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:atareao/telegram && apt update
    apt install -y telegram

    popd; echo "DONE_TELEGRAM=1" >> $LOGF
fi

answer "$AUTO_TRANSGUI" \
       "$DONE_TRANSGUI" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Transgui                                                                    |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    wget http://vorboss.dl.sourceforge.net/project/transgui/5.0.1/transgui-5.0.1-x86_64-linux.zip
    unzip transgui-5.0.1-x86_64-linux.zip
    mv transgui /usr/bin
    mv lang /usr/bin
    mv transgui.png /home/axa/.icons
    
    popd; echo "DONE_TRANSGUI=1" >> $LOGF
fi

answer "$AUTO_WEATHER_WIDGET" \
       "$DONE_WEATHER_WIDGET" \
       "+-----------------------------------------------------------------------------+\n" \
       "| WidGet погоды                                                               |\n" \
       "| http://www.noobslab.com/2015/04/                                            |\n" \
       "|    /04/gis-weather-widget-updated-and-now.html                              |\n" \
       "+----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository -y ppa:noobslab/apps && apt update
    apt install -y gis-weather

    popd; echo "DONE_WEATHER_WIDGET=1" >> $LOGF
fi

# --------------------------------------------------------------
#    Системы проектирования для электроники
#

answer "$AUTO_KICAD" \
       "$DONE_KICAD" \
       "+-----------------------------------------------------------------------------+\n" \
       "| KiCad 4.0.4 Stable Release                                                  |\n" \
       "| http://kicad-pcb.org/download/ubuntu/                                       |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository --yes ppa:js-reynaud/kicad-4
    apt update
    apt install kicad

    popd; echo "DONE_KICAD=1" >> $LOGF
fi

answer "$AUTO_STLINKV2_GUI" \
       "$DONE_STLINKV2_GUI" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Cross-platform STLink v2 GUI                                                |\n" \
       "| https://github.com/fpoussin/QStlink2                                        |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    add-apt-repository ppa:fpoussin/ppa
    apt-get update
    apt-get install qstlink2
    wget https://raw.githubusercontent.com/mobyfab/QStlink2/master/res/49-stlinkv2.rules
    mv 49-stlinkv2.rules /etc/udev/rules.d
    chown root:root /etc/udev/rules.d/49-stlinkv2.rules
    
    popd; echo "DONE_STLINKV2_GUI=1" >> $LOGF
fi

answer "$AUTO_OPENSTM32" \
       "$DONE_OPENSTM32" \
       "+-----------------------------------------------------------------------------+\n" \
       "| System Workbench for STM32                                                  |\n" \
       "| http://www.openstm32.org/HomePage                                           |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    
    mkdir -p /opt/Ac6/SystemWorkbench
    chown $USER:$GROUP /opt/Ac6/SystemWorkbench
    wget http://www.ac6-tools.com/downloads/SW4STM32/install_sw4stm32_linux_64bits-latest.run
    chmod +x ./install_sw4stm32_linux_64bits-latest.run
    sudo -u axa ./install_sw4stm32_linux_64bits-latest.run
    
    popd; echo "DONE_OPENSTM32=1" >> $LOGF
fi

answer "$AUTO_CROSSWORKS" \
       "$DONE_CROSSWORKS" \
       "+-----------------------------------------------------------------------------+\n" \
       "| CrossWorks for ARM                                                          |\n" \
       "|     is a complete C/C++ and assembly language development                   |\n" \
       "|     system for Cortex-M, Cortex-A, Cortex-R, ARM7, ARM9, ARM11, and XScale  |\n" \
       "|     microcontrollers.                                                       |\n" \
       "| http://www.rowley.co.uk/arm/index.htm                                       |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    
    wget -qO- http://cdn.rowleydownload.co.uk/arm/releases/arm_crossworks_4_0_0_linux_x64.tar.gz | tar xzv
    ./arm_crossworks_4_0_linux_x64/install_crossworks

    popd; echo "DONE_CROSSWORKS=1" >> $LOGF
fi

answer "$AUTO_SEGGER" \
       "$DONE_SEGGER" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Segger Embedded Studio                                                      |\n" \
       "|     is a streamlined and powerful C/C++ IDE for ARM microcontrollers.       |\n" \ 
       "|     It is specifically designed to provide you with everything needed for   |\n" \
       "|     professional embedded development: an all-in-one solution aiming at     |\n" \
       "|     stability and a continuous workflow                                     |\n" \
       "| https://www.segger.com/downloads/embeddedstudio                             |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;
    
    wget -qO- https://www.segger.com/downloads/files_static/embeddedstudio/Setup_EmbeddedStudio_v320_linux_x64.tar.gz | tar xzv
    ./segger_embedded_studio_320_linux_x64/install_segger_embedded_studio
    
    popd; echo "DONE_SEGGER=1" >> $LOGF
fi

answer "$AUTO_FRITZING" \
       "$DONE_FRITZING" \
       "+-----------------------------------------------------------------------------+\n" \
       "| Fritzing                                                                    |\n" \
       "| http://fritzing.org/home/                                                   |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then pushd /tmp;

    wget -qO- http://fritzing.org/download/0.9.3b/linux-64bit/fritzing-0.9.3b.linux.AMD64.tar.bz2 | tar xjv
    FRITZING=$(ls -d fritzing*)
    chown -R $USER:$GROUP "$FRITZING"
    
    popd; echo "DONE_FRITZING=1" >> $LOGF
fi

######################################################################
#     Заключительные коментарии:
# 1. Запустить unity tweak tool и установить Theme, Icons, Workspace settings
# 2. Установить дополнения к Firefox

