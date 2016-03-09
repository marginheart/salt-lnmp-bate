redis_source:
  cmd.run:
    - name: wget http://download.redis.io/releases/{{ pillar['redis_sof'] }} -P {{ pillar['sof_dir'] }}
    - unless: test -f {{ pillar['sof_dir'] }}/{{ pillar['redis_sof'] }}

redis_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: tar zxvf {{ pillar['redis_sof'] }} >> /dev/null
    - unless: test -d {{ pillar['redis_file'] }}
    - require:
      - cmd: redis_source

redis_dir:
  cmd.run:
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['redis_file'] }} {{ pillar['ins_dir'] }}/redis
    - unless: test -d {{ pillar['ins_dir'] }}/redis

redis_install:
  cmd.run:
    - cwd: {{ pillar['ins_dir'] }}/redis
    - name: make >>/dev/null
    - unless: test -f {{ pillar['ins_dir'] }}/redis/redis.conf
    - require:
      - cmd: redis_extract

redis_conf:
  file.managed:
    - name: {{ pillar['ins_dir'] }}/redis/redis.conf
    - source: salt://redis/redis.conf
    - require:
      - cmd: redis_install
