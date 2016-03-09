sof_dir:
  file.directory:
    - names:
      - {{ pillar['ins_dir'] }}
      - {{ pillar['sof_dir'] }}
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - unless: 
      - test -d {{ pillar['ins_dir'] }}
      - test -d {{ pillar['sof_dir'] }}

sql_dir:
  file.directory:
    - names:
      - {{ pillar['mysql_data'] }}
    - user: mysql
    - group: mysql
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - unless:
      - test -d {{ pillar['mysql_data'] }}
