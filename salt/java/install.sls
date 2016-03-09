java_source:
  file.managed:
    - name: {{ pillar['sof_dir'] }}/jdk-7u25-linux-x64.gz
    - source: salt://java/file/jdk-7u25-linux-x64.gz
    - unless: test -e {{ pillar['sof_dir'] }}/jdk-7u25-linux-x64.gz

java_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: tar zxvf jdk-7u25-linux-x64.gz >>/dev/null && cp -r jdk1.7.0_25 {{ pillar['ins_dir'] }}/jdk
    - unless:
      - test -d {{ pillar['ins_dir'] }}/jdk
    - requice:
      - file: java_source

java_command:
  cmd.run:
    - name: ln -s {{ pillar['ins_dir'] }}/jdk/bin/* /usr/bin/
    - onlyif: test -d {{ pillar['ins_dir'] }}/jdk
    - unless: test -f /usr/bin/java
    - requice:
      - cmd: java_extract

/etc/profile:
  file.append:
    - text:
      - "export JAVA_HOME={{ pillar['ins_dir'] }}/jdk"
      - "export JRE_HOME={{ pillar['ins_dir'] }}/jdk/jre"
      - "export PATH=$JAVA_HOME/bin:$JRE_HOME/bin:$PATH"
  cmd.run:
    - name: source /etc/profile
    - onlyif: cat /etc/profile |grep JAVA_HOME
