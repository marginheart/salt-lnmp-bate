include:
  - tools
mysql_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/mysql-5.5.40.tar.gz
    - unless: test -e {{ pillar['sof_dir'] }}/mysql-5.5.40.tar.gz
    - source: salt://mysql/file/mysql-5.5.40.tar.gz

extract_mysql:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - names:
      - tar zxvf mysql-5.5.40.tar.gz >> /dev/null
    - unless: test -d {{ pillar['sof_dir'] }}/mysql-5.5.40
    - require:
      - file: mysql_source

mysql_user:
  user.present:
    - name: mysql
    - uid: 1000
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin

data_create:
  file.directory:
    - name: {{ pillar['mysql_data']}}/data
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - unless:
      - test -d {{ pillar['mysql_data'] }}/data

logs_create:
  file.directory:
    - name: {{ pillar['mysql_data']}}/logs
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - unless:
      - test -d {{ pillar['mysql_data'] }}/logs
  
  
mysql_complie:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/mysql-5.5.40
    - names: 
      - cmake -DCMAKE_INSTALL_PREFIX={{ pillar['ins_dir'] }}/mysql -DMYSQL_UNIX_ADDR={{ pillar['ins_dir'] }}/mysql/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DWITH_EXTRA_CHARSETS:STRING=utf8,gbk -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DENABLED_LOCAL_INFILE=1 -DMYSQL_DATADIR={{ pillar['mysql_data'] }}/data -DMYSQL_TCP_PORT=3306 >> /dev/null &&make >>/dev/null &&make install >>/dev/null
    - require:
      - cmd: extract_mysql
      - pkg: tools_install
      - file: data_create
      - file: logs_create
    - unless: test -d {{ pillar['ins_dir'] }}/mysql
