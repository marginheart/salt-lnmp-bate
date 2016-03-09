include:
  - tools
  - nginx.install
  
nginx_dir:
  file.directory:
    - names:
      - {{ pillar['logs_dir'] }}
      - {{ pillar['ins_dir'] }}/nginx/conf/sites-enbled/
    - dir_mode: 755
    - makedir: True

nginx_conf:
  file.managed:
    - name: {{ pillar['ins_dir'] }}/nginx/conf/nginx.conf
    - source: salt://nginx/conf/nginx.conf
    - template: jinja
    - require:
      - cmd: nginx_complie
      
nginx_service:
  file.managed:
    - name: /etc/init.d/nginx
    - source: salt://nginx/conf/nginx
    - mode: 755
    - template: jinja
    - unless: test -f /etc/init.d/nginx
  cmd.run:
    - names:
      - /sbin/chkconfig nginx on
    - unless: /sbin/chkconfig --list nginx

nginx_enable:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: {{ pillar['ins_dir'] }}/nginx/conf/nginx.conf
      - file: /etc/init.d/nginx
    - sig: nginx
