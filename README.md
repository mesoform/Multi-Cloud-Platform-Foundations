# Multi-Cloud Platform Foundations

* [Mesoform Multi-Cloud Platform Foundations](#multi-cloud-platform-foundations)
  * [Background](#Background)
* [This Repository](#this-repository)
  * [MCCF](#MCCF)
* [Contributing](#Contributing)
* [License](#License)  

## Background
Mesoform Multi-Cloud Platform (MCP) is a set of tools and supporting infrastructure code which simplifies the deployment
of applications across multiple Cloud providers. The basis behind MCP is for platform engineers and application
engineers to be working with a single structure and configuration for deploying foundational infrastructure (like IAM
policies, Google App Engine or Kubernetes clusters) as would be used for deploying workloads to that infrastructure
(e.g. Containers/Pods).

Within this framework is a unified configuration language called Mesoform Multi-Cloud Configuration Format (or MCCF),
which is detailed below and provides a familiar YAML structure to what many of the native original services offer and
adapts it into HCL, the language of Hashicorp Terraform, and deploys it using Terraform, to gain the benefits (like
state management) which Terraform offers.


## MCCF
MCCF is a YAML-based configuration allowing for simple mapping of platform APIs for deploying applications. The adapters 
in this repository allow users to provide MCCF to configure these foundational resources as described [above](#this-repository).
Full details of MCCF can be found in the main [MCP repository](https://github.com/mesoform/Multi-Cloud-Platform).


# This Repository
This repository contains the codebase for IaaS and PaaS adapters necessary as part of a foundational platform to which 
MCP serverless/container workloads can be deployed to. For example, before a Google Cloud Run application can be deployed, 
there are some prerequisite resources that must exist and be configured beforehand - a Cloud Project, Service Account with 
suitable roles on an IAM policy. The adapters for deploying these exist here.

The adapters defined here are for resources which are part of a local context (within the scope of a single project team) 
but most likely managed by a core platform team because they introduce security risks. By using compliance considerations 
designed into MCCF, such teams can delegate the management of these resources to project teams whilst applying controls 
on their usage which may not be readily available through other tools (like Google Organisation Policies or AWS Guardrails)


# Contributing
Please read:

* [CONTRIBUTING.md](https://github.com/mesoform/documentation/blob/master/CONTRIBUTING.md)
* [CODE_OF_CONDUCT.md](https://github.com/mesoform/documentation/blob/master/CODE_OF_CONDUCT.md)


# License
This project is licensed under the [MPL 2.0](https://www.mozilla.org/en-US/MPL/2.0/FAQ/)
