include:
  - tools
  
libmcrypt_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/{{ pillar['libmcrypt_sof'] }}
    - unless: test -e {{ pillar['sof_dir'] }}/{{ pillar['libmcrypt_sof'] }}
    - source: salt://php/file/{{ pillar['libmcrypt_sof'] }}

php_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/{{ pillar['php_sof'] }}
    - unless: test -e {{ pillar['sof_dir'] }}/{{ pillar['php_sof'] }}
    - source: salt://php/file/{{ pillar['php_sof'] }}

php_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - names:
      - tar zxvf {{ pillar['php_sof'] }} >>/dev/null
    - unless:
      - test -d {{ pillar['php_file'] }}
    - require:
      - file: php_source

libmcrypt_exract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - names: 
      - tar zxvf {{ pillar['libmcrypt_sof'] }} >>/dev/null
    - unless: 
      - test -d {{ pillar['libmcrypt_file'] }}
    - require:
      - file: libmcrypt_source

libmcrypt_compile:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/{{ pillar['libmcrypt_file'] }}
    - name: ./configure >/dev/null && make >>/dev/null &&make install >> /dev/null
    - require:
      - cmd: libmcrypt_exract
    - unless: 
      - test -f /usr/local/lib/libmcrypt.so.4.4.8

php_tool:
  pkg.installed:
    {% if grains['os'] == 'CentOS' %}
    - name: re2c
    {% endif %}

php_complile:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/{{ pillar['php_file'] }}
    - name: ./configure --prefix={{ pillar['ins_dir'] }}/php --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-config-file-path={{ pillar['ins_dir'] }}/php/etc --enable-fpm  --with-fpm-user=www --with-fpm-group=www --with-curl --with-pear --with-gd --with-jpeg-dir --with-png-dir --with-zlib --with-xpm-dir --with-freetype-dir --with-mcrypt --with-mhash --with-openssl --with-xmlrpc --with-xsl --with-bz2 --with-gettext --disable-debug --enable-exif --enable-wddx --enable-zip --enable-bcmath --enable-calendar --enable-ftp --enable-mbstring --enable-soap --enable-sockets --enable-shmop --enable-dba --enable-sysvsem --enable-sysvshm --enable-sysvmsg --enable-pcntl --with-libedit --with-readline >>/dev/null && make >> /dev/null && make install >>/dev/null
    - require:
      - pkg: tools_install
      - cmd: php_extract
    - unless: test -d {{ pillar['ins_dir'] }}/php
