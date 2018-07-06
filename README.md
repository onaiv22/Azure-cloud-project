# Azure-cloud-project

I have been doing a lot of SysOps cloud deployments for my company and recently i decided all this work needs a high degree of automation. Therefore embracing Devops methodology in my approach becomes apparently inherent.

This particular project is one of those that I intend to use to practice my Infrastructure Development skills, and so entails deploying an automated infrastructure into Azure Cloud using Terraform.

As part of all that this repository will entail is...

## Phase 1

- A virtual Network with 2 Subnets (Public and Private)
- A Wordpress Website deployed in the Public subnet on 2 web servers, hardened with Security Group rules
- A database server deployed in the private subnet   
- A reverse proxy (Nginx) Serving load balancing for the web servers
- Continuous Integration (CI) with Jenkins as code.
- Configuration Management with Ansible/Powershel DSC

## Phase 2

- Later on I intend to embrace other technologies such as
      - Docker Swarm
      - Kubernetes
- Upgrade the Infrastructure into a Containerised architecture with High Availability and Fault Tolerance using Docker
- Introduce more applications to be deployed, and relying on other technologies such as
      - Elasticsearch
      - Logstash
      - Kibana
      - Grafana
      - Consul
      - Vault
      - Nomad
      - MongoDB


# TODO

- Refactor the code base to be more re-usable. Introduce variables accross the infrastructure
- Modularise the infrastructure as code (IAC)
- Wrap the deployment in Ansible
