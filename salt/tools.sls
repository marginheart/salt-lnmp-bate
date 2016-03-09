tools_install:
  pkg.installed:
    {% if grains['os'] == 'CentOS' %}
    - names:
      - epel-release
      - gcc
      - gcc-c++
      - make
      - bison
      - vim-enhanced
      - autoconf
      - libtool-ltdl-devel
      - gd-devel
      - freetype-devel
      - libxml2-devel
      - libjpeg-turbo-devel
      - libpng-devel
      - openssl-devel
      - libcurl-devel
      - patch
      - libmcrypt-devel
      - mhash-devel
      - ncurses-devel
      - bzip2
      - libcap-devel
      - ntp
      - unzip
      - diffutils
      - cmake
      - bzip2-devel
      - libedit-devel
      - libxslt-devel
      - wget
      - bash-completion
      - lrzsz
      - nc
      - telnet
      - iftop
    {% elif grains['os'] == 'Ubuntu' %}
    - names:
      - gcc
      - g++
      - make
      - autoconf  
      - libltdl-dev
      - libgd2-xpm-dev
      - libfreetype6
      - libfreetype6-dev
      - libxml2-dev
      - libjpeg-dev
      - libpng12-dev
      - libcurl4-openssl-dev
      - libssl-dev
      - patch
      - libmcrypt-dev
      - libmhash-dev
      - libncurses5-dev
      - libreadline-dev
      - bzip2
      - libcap-dev
      - ntpdate
      - curl
      - diffutils
      - unzip
      - cmake
      - vim
      - libbz2-dev
      - libedit-dev
      - libxslt1-dev
      - iftop
    {% endif %}

time_update:
  cmd.run:
    - name: ntpdate tiger.sina.com.cn
