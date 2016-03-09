include:
  - php.install

php_conf:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/{{ pillar['php_file'] }}
    - name: cp php.ini-production {{ pillar['ins_dir'] }}/php/etc/php.ini && sed -i 's/expose_php = On/expose_php = off/' {{ pillar['ins_dir'] }}/php/etc/php.ini
    - unless: 
      - test -e {{ pillar['ins_dir'] }}/php/etc/php.ini
    - requice:
      - cmd: php_complile

php_fpm_conf:
  file.managed:
    - name: {{ pillar['ins_dir'] }}/php/etc/php-fpm.conf
    - source: salt://php/conf/php-fpm.conf
    - unless: 
      - cmd: php_complile

php_server:
  file.managed:
    - name: /etc/init.d/php-fpm
    - user: www
    - mode: 755
    - source: salt://php/conf/php-fpm
    - template: jinja
  service.running:
    - name: php-fpm
    - enable: True
    - watch:
      - file: {{ pillar['ins_dir'] }}/php/etc/php-fpm.conf
    - sig: php-fpm
