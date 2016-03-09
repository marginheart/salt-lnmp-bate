include:
  - zabbix.install

zabbix_conf:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix/conf/zabbix_agentd.conf
    - template: jinja
    - require:
      - cmd: zabbix_install

zabbix_service:
  service.running:
    - name: zabbix-agent
    - enbled: True
    - watch:
      - file: /etc/zabbix/zabbix_agentd.conf
    - require:
      - file: zabbix_conf
  cmd.run:
    - name: chkconfig zabbix-agent on
    - unless: chkconfig --list zabbix-agent
