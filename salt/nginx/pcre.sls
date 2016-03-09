{% set sof_dir = '/data/software' %}
{% set pcre_sof = 'pcre-8.33.tar.gz' %}
{% set pcre_file = 'pcre-8.33' %}
pcre_source:
  file.managed:
    - name: {{ sof_dir }}/pcre-8.33.tar.gz
    - unless: {{ sof_dir }}/pcre-8.33.tar.gz
    - source: salt://nginx/file/pcre-8.33.tar.gz

pcre_extract:
  cmd.run:
    - cwd: {{ sof_dir }}
    - names:
      - tar zxvf {{ pcre_sof }} > /dev/null
    - unless:
      - test -d {{ sof_dir }}/pcre-8.33
    - requice:
      - file: pcre_source
