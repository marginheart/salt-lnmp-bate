files_source:
  file.managed:
    - names: 
      - {{ pillar['sof_dir'] }}/zabbix-agent-2.4.3-1.el6.x86_64.rpm
    - source: 
      - salt://zabbix/file/zabbix-agent-2.4.3-1.el6.x86_64.rpm
    - unless: 
      - test -f {{ pillar['sof_dir'] }}/zabbix-agent-2.4.3-1.el6.x86_64.rpm

zabbix_install:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: rpm -ivh zabbix-agent-2.4.3-1.el6.x86_64.rpm --nodeps --force
    - unless:
      - test -f /etc/zabbix/zabbix_agentd.conf
      - test -f /usr/bin/zabbix-agent
    - require:
      - file: files_source

zabbix_user:
    user.present:
    - name: zabbix
    - uid: 1002
    - createhome: False
    - gid_from_name: True
    - shell: /sbin/nologin

zabbix_dir:
  file.directory:
    - names:
      - /var/run/zabbix
      - /var/log/zabbix
    - user: zabbix
    - group: zabbix
    - dir_mode: 755
    - makedirs: True
    - recurse:
      - user
      - group
      - mode
    - unless:
      - test -d /var/run/zabbix
      - test -d /var/log/zabbix

zabbix_log:
  file.managed:
    - name: /var/log/zabbix/zabbix_agentd.log
    - user: zabbix
    - group: zabbix
    - file_mode: 755
    - unless:
      - test -f /var/log/zabbix/zabbix_agentd.log
