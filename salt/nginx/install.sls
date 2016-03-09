include:
  - tools

prce_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/{{ pillar['pcre_sof'] }}
    - unless: {{ pillar['sof_dir'] }}/{{ pillar['pcre_sof'] }}
    - source: salt://nginx/file/{{ pillar['pcre_sof'] }}
   
nginx_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/{{ pillar['nginx_sof'] }}
    - unless: {{ pillar['sof_dir'] }}/{{ pillar['nginx_sof'] }}
    - source: salt://nginx/file/{{ pillar['nginx_sof'] }}
    
sof_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - names: 
      - tar zxvf {{ pillar['pcre_sof'] }} > /dev/null
      - tar zxvf {{ pillar['nginx_sof'] }} > /dev/null
    - unless:
      - test -d {{ pillar['sof_dir'] }}/{{ pillar['pcre_file'] }}
      - test -d {{ pillar['sof_dir'] }}/{{ pillar['nginx_file'] }}
    - requice:
      - file: prce_source
      - file: nginx_source
    
nginx_user:
  user.present:
    - name: www
    - uid: 1001
    - createhome: False
    - gid_from_name: Ture
    - shell: /sbin/nologin
    
nginx_complie:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/{{ pillar['nginx_file'] }}
    - name: ./configure --user=www --group=www --prefix={{ pillar['ins_dir'] }}/nginx --with-pcre={{ pillar['sof_dir'] }}/{{ pillar['pcre_file'] }} --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module >>/dev/null&& make >>/dev/null && make install >>/dev/null
    - requice:
      - pkg: tools_install
      - cmd: sof_extract
    - unless: test -d {{ pillar['ins_dir'] }}/nginx
