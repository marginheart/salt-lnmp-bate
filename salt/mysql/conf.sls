include:
  - mysql.install
  - dir
mysql_conf:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/conf/my.cnf
    - template: jinja

mysqld:
  cmd.run:
    - names:
      - cp {{ pillar['sof_dir'] }}/mysql-5.5.40/support-files/mysql.server /etc/init.d/mysqld &&/bin/chmod +x /etc/init.d/mysqld
    - unless: test -f /etc/init.d/mysqld
    - onlyif: test -d {{ pillar['ins_dir'] }}/mysql
    - require:
      - file: mysql_conf

mysql_init:
  cmd.run:
    - names:
      - {{ pillar['ins_dir'] }}/mysql/scripts/mysql_install_db --user=mysql --basedir={{ pillar['ins_dir'] }}/mysql --datadir={{ pillar['mysql_data'] }}/data
      - chown -R mysql:mysql {{ pillar['ins_dir'] }}/mysql
    - require:
      - cmd: mysqld


mysql_service:
  cmd.run:
    - names:
      - /sbin/chkconfig mysqld on
      - chown -R mysql:mysql {{ pillar['mysql_data'] }}
    - unless:
      - /sbin/chkconfig --list mysqld
  service.running:
    - name: mysqld
    - enable: True
    - watch:
      - file: /etc/my.cnf
