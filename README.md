# ansible-cortex

Deploy [Cortex](https://github.com/cortexproject/cortex) or [Grafana Metrics Enterprise](https://grafana.com/products/metrics-enterprise/) (horizontally scalable, highly available, multi-tenant, long term Prometheus) using Ansible.

## Requirements

- Ansible >= 2.8 (lower version may work but are untested)

## Role variables

| Name | Default value | Description |
| ---- | ------------- | ----------- |
| enterprise | `false` | Set to `true` to deploy Grafana Metrics Enterprise instead of Cortex. |
| name | `"{% if enterprise -%} metrics-enterprise {%- else -%} cortex {%- endif %}"` | Name of the service, used to interpolate file names, service names, etc.. `name` is parameterized for use with different targets like `compactor`. |
| bin\_name | `"{% if enterprise -%} metrics-enterprise {%- else -%} cortex {%- endif %}"` | Name of the binary on the remote system. Parameterized so that multiple services on a single host can use the same binary. |
| bin\_dir | `"/usr/local/bin"` | Directory in which to install the binary. |
| config\_dir | `"/etc/{{ name }}"` | Directory in which configuration files are stored. |
| config\_file | `"{{ name }}.yml"` | Name of the configuration file. Combined with `config\_dir` for the absolute path to the servers configuration file. |
| config\_template | `"{{ name }}.yml.j2"` | Name of the local template file used for templating the Cortex/Grafana Metrics Enterprise configuration file. |
| data\_dir | `"/var/lib/{{ name }}"` | Directory used as the users home directory and where server files (like the write-ahead log) are stored by default. |
| http\_listen\_port | `9009` | Server HTTP port. |
| user | `"{{ name }}"` | Name for the user running the server. |
| group | `"{{ name }}"` | Name for the group running the server. |
| bin\_arguments | `["-config.file={{ config_dir }}/{{ config_file }}"]` | List of command line arguments passed to the binary. |
| cortex\_version | `"1.4.0"` | Cortex version without leading 'v'. If "latest" is used, the playbook will download the latest. Using "latest" is not recommended for production use. |
| cortex\_checksum | `"15982475d875ca1f7c8b70e7cf48b0c5ad850d7eb73f8789c0a60bf57effac57"` | SHA256 checksum for the Cortex binary. |
| metrics\_enterprise\_version | `"1.0.2"` | Grafana Metrics Enterprise version without a leading 'v'. |
| metrics\_enterprise\_checksum | `"dceda7c43bcde4b76c5aab9cd9da1db7aa01df5f99dec2bdfcceaf49ecafb708"` | SHA256 checksum for the Grafana Metrics Enterprise binary. |
| metrics\_enterprise\_cluster\_name | | Name of the cluster configured in the Grafana Labs issued license file. |
| metrics\_enterprise\_license_file | | Name of the Grafana Labs issued license file. |


## Example playbooks

> More examples can be found by reviewing the test scenarios in `/molecule`

### Single process Cortex

Start a single instance of Cortex running in single process mode with the blocks storage engine configured to use the local filesystem as a store. Cortex servers will not cluster with this configuration.

```yaml
---
- hosts: all
  roles: jdbaldry/ansible-cortex
```

### Single process Grafana Metrics Enterprise

Start a single instance of Grafana Metrics Enterprise running in single process mode with the blocks storage engine configured to use the local filesystem as a store.
Grafana Metrics Enterpise servers will not cluster with this configuration.

```yaml
---
- hosts: all
  roles: jdbaldry/ansible-cortex
  vars:
    enterprise: true
    metrics_enterprise_cluster_name: my-grafana-metrics-enterprise-cluster
    metrics_enterprise_license_file: license.jwt
```

## License

Apache License 2.0
