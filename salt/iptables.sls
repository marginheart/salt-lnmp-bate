stop_iptables:
  service.dead:
    - name: iptables
