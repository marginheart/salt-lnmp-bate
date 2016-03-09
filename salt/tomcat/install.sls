tomcat_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/{{ pillar['tomcat_sof'] }}
    - unless: {{ pillar['sof_dir'] }}/{{ pillar['tomcat_sof'] }}
    - source: salt://tomcat/file/{{ pillar['tomcat_sof'] }}

tomcat_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: tar zxvf {{ pillar['tomcat_sof'] }} > /dev/null
    - unless: test -d {{ pillar['tomcat_file'] }}
    - requice:
      - file: tomcat_source

tomcat_order:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['tomcat_file'] }} {{ pillar['ins_dir'] }}/{{ pillar['tom_order'] }}
    - unless: test -d {{ pillar['ins_dir'] }}/{{ pillar['tom_order'] }}
    - requice:
      - cmd: tomcat_extract
  file.managed:
    - name: {{ pillar['ins_dir'] }}/{{ pillar['tom_order'] }}/conf/server.xml
    - source: salt://tomcat/conf/server.xml
    - template: jinja
    - shut_port: {{ pillar['order_shut_port'] }}
    - run_port: {{ pillar['order_run_port'] }}
    - re_port: {{ pillar['order_re_port'] }}
    - ssl_port: {{ pillar['order_ssl_port'] }}

tomcat_data:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['tomcat_file'] }} {{ pillar['ins_dir'] }}/{{ pillar['tom_data'] }}
    - unless: test -d {{ pillar['ins_dir'] }}/{{ pillar['tom_data'] }}
    - requice:
      - cmd: tomcat_extract
  file.managed:
    - name: {{ pillar['ins_dir'] }}/{{ pillar['tom_data'] }}/conf/server.xml
    - source: salt://tomcat/conf/server.xml
    - template: jinja
    - shut_port: {{ pillar['data_shut_port'] }}
    - run_port: {{ pillar['data_run_port'] }}
    - re_port: {{ pillar['data_re_port'] }}
    - ssl_port: {{ pillar['data_ssl_port'] }}

tomcat_website:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['tomcat_file'] }} {{ pillar['ins_dir'] }}/{{ pillar['tom_website'] }}
    - unless: test -d {{ pillar['ins_dir'] }}/{{ pillar['tom_website'] }}
    - requice:
      - cmd: tomcat_extract
  file.managed:
    - name: {{ pillar['ins_dir'] }}/{{ pillar['tom_website'] }}/conf/server.xml
    - source: salt://tomcat/conf/server.xml
    - template: jinja
    - shut_port: {{ pillar['website_shut_port'] }}
    - run_port: {{ pillar['website_run_port'] }}
    - re_port: {{ pillar['website_re_port'] }}
    - ssl_port: {{ pillar['website_ssl_port'] }}
  
tomcat_movie:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['tomcat_file'] }} {{ pillar['ins_dir'] }}/{{ pillar['tom_movie'] }}
    - unless: test -d {{ pillar['ins_dir'] }}/{{ pillar['tom_movie'] }}
    - requice:
      - cmd: tomcat_extract
  file.managed:
    - name: {{ pillar['ins_dir'] }}/{{ pillar['tom_movie'] }}/conf/server.xml
    - source: salt://tomcat/conf/server.xml
    - template: jinja
    - shut_port: {{ pillar['movie_shut_port'] }}
    - run_port: {{ pillar['movie_run_port'] }}
    - re_port: {{ pillar['movie_re_port'] }}
    - ssl_port: {{ pillar['movie_ssl_port'] }}

tomcat_coupon:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: cp -r {{ pillar['sof_dir'] }}/{{ pillar['tomcat_file'] }} {{ pillar['ins_dir'] }}/{{ pillar['tom_coupon'] }}
    - unless: test -d {{ pillar['ins_dir'] }}/{{ pillar['tom_coupon'] }}
    - requice:
      - cmd: tomcat_extract
  file.managed:
    - name: {{ pillar['ins_dir'] }}/{{ pillar['tom_coupon'] }}/conf/server.xml
    - source: salt://tomcat/conf/server.xml
    - template: jinja
    - shut_port: {{ pillar['coupon_shut_port'] }}
    - run_port: {{ pillar['coupon_run_port'] }}
    - re_port: {{ pillar['coupon_re_port'] }}
    - ssl_port: {{ pillar['coupon_ssl_port'] }}
