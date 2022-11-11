## Elite-Datadog-Monitoring
Datadog is a monitoring and analytics tool for information technology (IT) and DevOps teams that can be used to determine performance metrics as well as event monitoring for infrastructure and cloud services. The software can monitor services such as servers, databases and tools.

Datadog monitoring software is available for deployment on premises or as a software as a service (SaaS). Datadog supports Windows, Linux, and Mac operating systems. Support for cloud service providers includes AWS, Microsoft Azure, Red Hat OpenShift and Google Cloud Platform.

```
# Install the Datadog role from Ansible Galaxy on your Ansible server:
Run command:

`ansible-galaxy install datadog.datadog`

```
- hosts: dev
  roles:
    - { role: datadog.datadog, become: yes }
  vars:
    datadog_api_key: 
    with_items:
       - "{{ datadog_api_key }}"
```
```
# Inventory file
```

```
---
all:
  children:
    server:
      hosts:
        dev:
          ansible_host: <EC2IPHOST>
```
# Run the playbook
Run command:

`ansible-playbook datadog.yml -i datadog-inventory.yml -vvvv`

# documentation reference
https://elitesolutionit.atlassian.net/wiki/spaces/~62334c2d1c09d2007014fa00/pages/1114280/datadog+install+on+ubuntu+with+ansible