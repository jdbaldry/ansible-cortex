# Ansible Role: cortex

Deploy [Cortex](https://github.com/cortexproject/cortex) or [Grafana Metrics Enterprise](https://grafana.com/products/metrics-enterprise/) (horizontally scalable, highly available, mult-tenant, long term Prometheus) using Ansible.

## Requirements

- Ansible >= 2.8 (lower version may work but are untested)

## Role variables

| Name | Default value | Description |

## Example playbook

```yaml
---
- hosts: all
  roles: jdbaldry/ansible-cortex
```

## License

Apache License 2.0
