git_source:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: wget https://codeload.github.com/git/git/zip/master -O git.zip
    - unless: test -f {{ pillar['sof_dir'] }}/git.zip

git_extract:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}
    - name: unzip git.zip >>/dev/null
    - unless: test -d {{ pillar['sof_dir'] }}/git-master
    - requice:
      - cmd: git_source
sof_install:
  pkg.installed:
    {% if grains['os'] == 'CentOS' %}
    - names:
      - expat-devel
      - gettext-devel
      - perl-ExtUtils-MakeMaker 
    {% endif %}

git_install:
  cmd.run:
    - cwd: {{ pillar['sof_dir'] }}/git-master
    - name: make prefix={{ pillar['ins_dir'] }}/git all >>/dev/null && make prefix={{ pillar['ins_dir'] }}/git install >>/dev/null
    - unless: test -d {{ pillar['ins_dir'] }}/git
    - requice:
      - cmd: git_extract
git_like:
  cmd.run:
    - name: ln -s {{ pillar['ins_dir'] }}/git/bin/* /usr/bin/
    - onlyif: test -d {{ pillar['ins_dir'] }}/git
    - unless: test -f /usr/bin/git
    - requice:
      - cmd: git_install
