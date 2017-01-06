#!/bin/bash

################################################################## 
#   Changes
# 160822 - added Solaar install

OS="Ubuntu 16.04"
SCR_VER="16.04-2016-11-06"

USER="axa"    # проверьте имя USER. Оно подставится при установке nfs
DEBUG=0

#set -e

C_NRM="\e[0m"
C_RED="\e[1;49;91m"
C_GRN="\e[1;49;32m"
C_YEL="\e[1;49;33m"
C_BLU="\e[1;49;94m"
C_CYA="\e[1;49;96m"

AUTO=0
AVAHI=1

answer ()
{
    echo -e "\n\n${C_CYA} $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11} ${12} ${13} ${14} ${15} ${16} ${17} ${18} ${19} ${20} ${21} ${C_NRM}"
    for(( DONE=0; DONE == 0;  ))
    {
        if [ $AUTO = "N" ]; then
            read -p "Continue ? (Y)es, (A)bort, (S)kip : " VAL
        else
            VAL="Yes"    # Пакетная установка. Автомтаический ответ Yes.
        fi
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
    }
}

#  функция использовлась для отладки общего хода исполения для имитации установки
fakeInstall()
{
    echo "Пропускаем ..."
    sleep 2
}

######################################################################
#     Начало скрипта


VAL=$1
VAL=${VAL:0:1}
if [ $VAL = "A" ]; then AUTO="Y"; fi

answer "===========================================================\n" \
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
#  Проверка на то, что мы запускаем под Рутом
#   sudo -i 
# --------------------------------------------------------------

USR=`whoami`
if [ "$USR" != "root" ]; then
    echo "Run $0 ar superuser"
    exit 1
fi

cd /tmp

#if [ $AUTO -a $AVAHI ]; then ANS="Y"
#else
answer "+------------------------------------------------------------------------+\n" \
       "|   Выключенить отправку отчета об ошибках, Avahi                        |\n" \
       "|   Отключенить сервис Avahi                                             |\n" \
       "+------------------------------------------------------------------------+"
#fi
if [ $ANS = "Y" ]; then
    sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
    service apport stop
    sed -i 's/AVAHI_DAEMON_DETECT_LOCAL=1/AVAHI_DAEMON_DETECT_LOCAL=0/g' /etc/default/avahi-daemon
fi

answer "+------------------------------------------------------------------------+\n" \
       "| В Ubuntu 16.04 присутствует баг, проявляющийся в виде моргания экрана  |\n" \
       "| Установка firmware от Intel устраняет этот баг.                        |\n" \
       "|                                                                        |\n" \
       "|   Установить firmware для i915 ?                                       |\n" \
       "|   Установить параметры для работы драйвера ?                           |\n" \
       "|  options i915 enable_rc6=7 enable_psr=2                                |\n" \
       "|      enable_fbc=1 lvds_downclock=1 semaphores=1                        |\n" \
       "+------------------------------------------------------------------------+"
if [ $ANS = "Y" ]; then
    cd /tmp
    wget https://download.01.org/gfx/ubuntu/16.04/main/pool/main/i/intel-graphics-update-tool/intel-graphics-update-tool_2.0.2_amd64.deb
    dpkg --install intel-graphics-update-tool_2.0.2_amd64.deb
    intel-graphics-update-tool_2.0.2_amd64.deb
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Устанавливаем Brother MFC-7840wr System setting->Printers              |\n" \
       "|   после - сканер, основано на инструкции                               |\n" \
       "+------------------------------------------------------------------------+\n"
# http://askubuntu.com/questions/791556/not-working-brother-scanner-in-ubuntu-16-04-though-driver-installed
if [ $ANS = "Y" ]; then
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

fi

answer "+------------------------------------------------------------------------+\n" \
       "| Устанавливаем HPLiP ?                                                  |\n" \
       "|     sudo -u axa sh hplip-3.16.10.run                                   |\n" \
       "+------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then
    wget http://vorboss.dl.sourceforge.net/project/hplip/hplip/3.16.10/hplip-3.16.10.run
    chmod +x hplip-3.16.10.run
    sudo -u $USER sh hplip-3.16.10.run
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Last version of:                                                       |\n" \
       "|   midnight commander                                                   |\n" \
       "|   Double commander                                                     |\n" \
       "|   Krusader                                                             |\n" \
       "| Archivers:                                                             |\n" \
       "|   p7zip-full p7zip-rar unace rar unrar zip unzip                       |\n" \
       "|   sharutils uudeview mpack arj cabextract                              |\n" \
       "|   file-roller                                                          |\n" \
       "| Utilities:                                                             |\n" \
       "|   htop powertop gparted ssh exFat driver                               |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:eugenesan/ppa && apt update
    apt install -y mc
    add-apt-repository -y ppa:alexx2000/doublecmd && apt update 
    apt install -y doublecmd-gtk krusader
    apt install -y p7zip-full p7zip-rar unace unrar zip unzip sharutils \
                   uudeview mpack arj cabextract file-roller rar htop powertop \
                   gparted ssh exfat-fuse exfat-utils
    # Add start powertop whithout password
    sed -i '/# User privilege specification/a axa     ALL=(root) /usr/sbin/powertop' /etc/sudoers
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  Solaar - Logtech radio mice tool                                      |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    apt install -y solaar
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Gnome font manager                                                     |\n" \
       "| Устанавливить из репозитория разработчика:                             |\n" \
       "|   ppa:font-manager/staging  ?                                          |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:font-manager/staging && apt-get update
    apt install -y font-manager
fi          

# --------------------------------------------------------------
# Buggy in 14.04
# echo "Установливаем gXneur"
#add-apt-repository -y ppa:andrew-crew-kuznetsov/xneur-unstable && apt update
#apt install -y xneur gxneur
# Ubuntu 13.04 not supported
#gsettings set com.canonical.Unity.Panel systray-whitelist "['all']" 

answer "+------------------------------------------------------------------------+\n" \
       "| nfs client and autonfs                                                 |\n" \
       "|   http://sysadm.pp.ua/linux/nfs-and-autofs.html                        |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    apt install -y nfs-common
#    if [ ! -d /media/srv1d0 ]; then mkdir -p /media/srv1d0; fi
#    sh -c '#echo "192.168.56.63:/mnt/hdd1t0                              /media/srv1d0     nfs   rsize=32768,wsize=32768,timeo=14,soft,intr,noatime,noauto     0       0" >> /etc/fstab'
#    if [ ! -d /media/nas4d0 ]; then mkdir -p /media/nas4d0; fi
#    sh -c '#echo "192.168.56.66:/raid0/data/_NAS_NFS_Exports_/Nas4d0      /media/nas4d0     nfs   rsize=32768,wsize=32768,timeo=14,soft,intr,noatime,noauto     0       0" >> /etc/fstab'
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
    cd /tmp
fi

answer "+------------------------------------------------------------------------+\n" \
       "| compiz, ccsm, dconf-editor                                             |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    apt install -y compiz compizconfig-settings-manager compiz-plugins-extra dconf-editor
fi

answer "+------------------------------------------------------------------------+\n" \
       "| ubuntu-tweak, Unity Tweak Tool, Gnome Tweak Tool                       |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    wget http://archive.getdeb.net/ubuntu/pool/apps/u/ubuntu-tweak/ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
    dpkg -i ubuntu-tweak_0.8.7-1~getdeb2~xenial_all.deb
    apt install -f
    apt install -y unity-tweak-tool gnome-tweak-tool
fi


# --------------------------------------------------------------
#  http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html 
answer "+------------------------------------------------------------------------+\n" \
       "| Устанавливаем Oracle Java(TM) SE Runtime Environment                   |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:webupd8team/java && apt update
    apt install -y oracle-java8-installer
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  notify-osd                                                            |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    # http://www.webupd8.org/2011/05/configurable-notifyosd-bubbles-for.html
    # https://launchpad.net/~leolik/+archive/ubuntu/leolik
    add-apt-repository -y ppa:leolik/leolik && apt update && apt upgrade
    apt install -y libnotify-bin
    add-apt-repository -y ppa:nilarimogard/webupd8 && apt update && apt upgrade
    apt install -y notifyosdconfig
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Themes and Icons:                                                      |\n" \
       "| http://www.noobslab.com/2016/03/vivacious-colors-gtk-theme-suite.html  |\n" \
       "| http://www.noobslab.com/2013/                                          |\n" \
       "|     07/nouvegnome-color-and-gray-icon-sets-for.html                    |\n" \
       "|                                                                        |\n" \
       "| Use Ubuntu Tweak after                                                 |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:ravefinity-project/ppa && sudo apt update
    apt install -y vivacious-colors-gtk-dark \
                         vivacious-colors-gtk-light \
                         vivacious-unity-gtk-dark \
                         vivacious-unity-gtk-light
    add-apt-repository -y ppa:noobslab/icons && apt-get update
    apt install -y nouvegnome-gray
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  Diodon Clipboard Manager                                              |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    apt install -y diodon
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  stickynotes Indicator                                                 |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:umang/indicator-stickynotes && apt update
    apt install -y indicator-stickynotes
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  rednotebook Indicator                                                 |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:rednotebook/daily && sudo apt update
    apt install -y rednotebook
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Gnome 3                                                                |\n" \
       "| http://www.omgubuntu.co.uk/2016/05/                                    |\n" \
       "|              install-gnome-3-20-ubuntu-16-04-lts                       |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:gnome3-team/gnome3-staging
    add-apt-repository -y ppa:gnome3-team/gnome3fi
    apt update
    apt dist-upgrade -y
    apt install -y gnome gnome-shell
fi
# --------------------------------------------------------------
#echo "Устанавливаем Gnome 3"
#add-apt-repository -y ppa:gnome3-team/gnome3 && sudo apt -y update
#apt install -y gnome-shell gnome-tweak-tool
# для Gnome 3 устанавливаем Gpaste
#add-apt-repository -y ppa:webupd8team/gnome3
#apt update && sudo apt install -y gnome-shell-extensions-gpaste
# Установка Gnome Classic
#apt install -y gnome-session-fallback


answer "+------------------------------------------------------------------------+\n" \
       "| OwnCloud Desktop Client                                                |\n" \
       "| https://software.opensuse.org/download/                                |\n" \
       "|   package?project=isv:ownCloud:desktop&package=owncloud-client         |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    wget http://download.opensuse.org/repositories/isv:ownCloud:desktop/Ubuntu_16.04/Release.key
    sudo apt-key add - < Release.key
    sudo apt-get update
    apt install -y owncloud-client
fi


# ##############################################################
#                          Audio
answer "+------------------------------------------------------------------------+\n" \
       "|  Audio multimedia codecs                                               |\n" \
       "|  command line player, ogg vorbis tools                                 |\n" \
       "|  Tags editor and GUI player                                            |\n" \
       "|  vlc browser-plugin-vlc                                                |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
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
fi

answer "+------------------------------------------------------------------------+\n" \
       "| audacious 3.5                                                          |\n" \
       "+------------------------------------------------------------------------+" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:nilarimogard/webupd8 && apt update
    apt install -y audacious
fi


# ##############################################################
#        Development tools

answer "+------------------------------------------------------------------------+\n" \
       "| Install Development tools                                              |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y g++ md5deep fakeroot \
                   geany geany-plugins \
                   cmake bless \
                   python3-setuptools
    easy_install3 -y pip
fi

answer "+------------------------------------------------------------------------+\n" \
       "| PyCharm                                                                |\n" \
       "|   https://бэкдор.рф/pycharm-activate-key-3-4-5-2016                    |\n" \
       "+------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:mystic-mirage/pycharm && apt update
    apt install -y pycharm
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Qt 5.7 и PyQt                                                          |\n" \
       "+------------------------------------------------------------------------+\n"
if [ $ANS = "Y" ]; then
    wget http://download.qt-project.org/official_releases/qt/5.7/5.7.0/qt-opensource-linux-x64-5.7.0.run
    chmod +x qt-opensource-linux-x64-5.7.0.run
    ./qt-opensource-linux-x64-5.7.0.run
    apt install -y build-essential python3-dev python3-pyqt5 pyqt5-dev-tools
    pip3 install SIP
fi

answer "+------------------------------------------------------------------------+\n" \
       "| KiCad 4.0.4 Stable Release                                             |\n" \
       "| http://kicad-pcb.org/download/ubuntu/                                  |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    sudo add-apt-repository --yes ppa:js-reynaud/kicad-4
    sudo apt update
    sudo apt install kicad
fi


answer "+------------------------------------------------------------------------+\n" \
       "| YAD форк Zenity                                                        |\n" \
       "|------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:webupd8team/y-ppa-manager && apt update
    apt install -y yad
fi

echo -e "Устанавливаем Android Studio\n https://developer.android.com/studio/index.html\n"

# ##############################################################
#        Приложения

answer "+------------------------------------------------------------------------+\n" \
       "| coolreader, fbreader                                                   |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    #add-apt-repository -y ppa:vovansrnd/coolreader && apt update
    #apt install cr3
    # Сборки под 16.04 пока нет.
    wget http://ppa.launchpad.net/vovansrnd/coolreader/ubuntu/pool/main/c/cr3/cr3_3.1.2.3-39_amd64.deb
    sudo dpkg --install cr3_3.1.2.3-39_amd64.deb
    apt install -f
    wget http://dl.dropbox.com/u/22272434/src/cr3.ini -O ~/.cr3/cr3.ini
    ln -s /usr/share/cr3/backgrounds/ ~/.cr3/backgrounds
    apt install -y fbreader
fi

answer "+-----------------------------------------------------------------------------+\n" \
       "| http://fb2edit.lintest.ru/                                                  |\n" \
       "| http://linuxmasterclub.ru/fb2edit/                                          |\n" \
       "|                                                                             |\n" \
       "| http://ubuntuhandbook.org/index.php/2016/06/sigil-0-9-6-ppa-ubuntu-16-04/   |\n" \
       "| https://github.com/Sigil-Ebook/Sigil                                        |\n" \
       "+-----------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    # сборки для 16.04 нет. Ставим сборку от 14.04
    #add-apt-repository -y ppa:lintest/fb2edit
    #apt update && apt install fb2edit
    wget https://launchpadlibrarian.net/180250769/fb2edit_0.0.9-utopic2_amd64.deb
    dpkg --install fb2edit_0.0.9-utopic2_amd64.deb

    add-apt-repository -y ppa:ubuntuhandbook1/sigil
    apt update && apt install -y sigil sigil-data
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Sony Prs-505 sync manager                                              |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    wget http://AxaRu.opendrive.com/files/68506444_wLMCL_a43e/mngr505
    chmod +x mngr505
    mv mngr505 /usr/bin
fi

answer "+------------------------------------------------------------------------+\n" \
       "|   LibreOffice                                                          |\n" \
       "|   removing default LibreOffice and reinstall actual version            |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    # Ubuntu 16.04 Libreoffice Version: 5.1.4.2
    apt remove --purge -y libreoffice*
    apt clean -y
    apt autoremove -y
    add-apt-repository -y ppa:libreoffice/ppa && apt update
    apt install -y libreoffice libreoffice-help-ru libreoffice-l10n-ru
    # расстановка переносов
    apt install -y openoffice.org-hyphenation
fi

answer "+------------------------------------------------------------------------+\n" \
       "|   Устанавливаем Русские словари для gedit и т.п.                       |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
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
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  GoldenDict                                                            |\n" \
       "|  http://ubuntuportal.com/2013/02/goldendict-complete-dictionary-       |\n" \
       "|      app-for-ubuntu-based-distribution.html                            |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y goldendict
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  keepassx                                                              |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y keepassx
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  gnucash                                                               |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y gnucash
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  Graphical tools                                                       |\n" \
       "|    Gimp, shutter, inkscape, digikam, dia                               |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    apt install -y gimp gimp-data gimp-plugin-registry gimp-data-extras \
                   shutter inkscape digikam dia calligraflow imagemagick
fi

answer "+------------------------------------------------------------------------+\n" \
       "|  Skype, Telegram                                                       |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
    dpkg --add-architecture i386
    apt-get update
    apt install -y skype
    add-apt-repository -y ppa:atareao/telegram && apt update
    apt install -y telegram
fi

answer "+------------------------------------------------------------------------+\n" \
       "| Transgui                                                               |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    wget http://vorboss.dl.sourceforge.net/project/transgui/5.0.1/transgui-5.0.1-x86_64-linux.zip
    unzip transgui-5.0.1-x86_64-linux.zip
    mv transgui /usr/bin
    mv lang /usr/bin
    mv transgui.png /home/axa/.icons
fi

answer "+------------------------------------------------------------------------+\n" \
       "| WidGet погоды                                                          |\n" \
       "| http://www.noobslab.com/2015/04/                                       |\n" \
       "|    /04/gis-weather-widget-updated-and-now.html                         |\n" \
       "+------------------------------------------------------------------------+\n" 
if [ $ANS = "Y" ]; then
    add-apt-repository -y ppa:noobslab/apps && apt update
    apt install -y gis-weather
fi


######################################################################
#     Заключительные коментарии:
# 1. Запустить unity tweak tool и установить Theme, Icons, Workspace settings
# 2. Установить дополнения к Firefox

