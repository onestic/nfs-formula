{% from "nfs/map.jinja" import nfs with context %}

nfs-server-deps:
    pkg.installed:
        - pkgs: {{ nfs.pkgs_server|json }}

/etc/exports:
  file.managed:
    - source: salt://nfs/files/exports
    - template: jinja
    - watch_in:
      - service: nfs-service

{% for export_dir in pillar['nfs']['server']['exports'].keys() %}
{{ export_dir }}:
  file.directory:
    - dir_mode: 755
    - file_mode: 644
{% endfor %}

{% if grains['os_family'] == 'RedHat' %}
rpcbind-service:
  service.running:
    - name: rpcbind
    - enable: True
{% endif %}

nfs-service:
  service.running:
    - name: {{ nfs.service_name }}
    - enable: True
