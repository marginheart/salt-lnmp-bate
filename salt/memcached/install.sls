memcached:
  pkg.installed

mem_conf:
  file.replace:
    {% if grains['os'] == 'CentOS' %}
    - name: /etc/sysconfig/memcached
    - pattern: CACHESIZE="64"
    - repl: CACHESIZE="1024"
    - backup: .bak
    - unless:
       - pkg: memcached
    {% elif grains['os'] == 'Ubuntu' %}
    - name: /etc/memcached.conf
    - pattern: -m 64
    - repl: -m 1024
    - backup: .bak
    - unless:
      - pkg: memcached
    {% endif %}
  service.running:
    - name: memcached
    - enble: True
  {% if grains['os'] == 'Centos' %}
    - watch:
      - file: /etc/sysconfig/memcached
  {% elif grains['os'] == 'Ubuntu' %}
    - watch:
      - file: /etc/memcached.conf
  {% endif %}
