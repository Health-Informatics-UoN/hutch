![Hutch][hutch-logo]

**Hutch** is part of an application stack for **Federated Activities**, such as Analytics, Data Discovery or Machine Learning.

## Hutch-Trefx 
[Hutch-Trefx](https://github.com/Health-Informatics-UoN/hutch-trefx/tree/main) is an Executing Agent implementation that accepts jobs from a TRE Agent, executes them and records outputs and provenance, submitting the results to be approved for egress.

## Cohort Discovery

### 🐇 [Bunny](https://github.com/Health-Informatics-UoN/hutch-bunny) ![MIT License][license-badge]

| | | |
|-|-|-|
| ![Python][python-badge] | [![Bunny Docker Images][docker-badge]][bunny-containers] | [![Bunny Docs][docs-badge]][bunny-docs] |

A Cohort Discovery Task Resolver.

Fetches and resolves Availability and Distribution Queries against a PostgreSQL OMOP CDM database.

### 🔄 [Relay](https://github.com/Health-Informatics-UoN/hutch-relay) ![MIT License][license-badge]

| | | |
|-|-|-|
| ![.NET][dotnet-badge] | [![Relay Docker Images][docker-badge]][relay-containers] | [![Relay Docs][docs-badge]][relay-docs] |

A Federated Proxy for a Cohort Discovery Task API.

- Connects to an upstream Task API (e.g. the HDR UK Cohort Discovery Tool).
- Fetches tasks.
- Queues them for one or more downstream sub nodes (e.g. Bunny instances).
- Accepts task results from the downstream nodes.
- Submits aggregate results to the upstream Task API.

Implements a subset of the Task API for the downstream nodes to interact with.


[hutch-logo]: https://raw.githubusercontent.com/HDRUK/hutch/main/assets/Hutch%20splash%20bg.svg
[hutch-repo]: https://github.com/health-informatics-uon/hutch

[bunny-docs]: https://health-informatics-uon.github.io/hutch/bunny
[bunny-containers]: https://github.com/Health-Informatics-UoN/hutch-bunny/pkgs/container/hutch%2Fbunny

[relay-docs]: https://health-informatics-uon.github.io/hutch/relay
[relay-containers]: https://github.com/Health-Informatics-UoN/hutch-relay/pkgs/container/hutch%2Frelay

[license-badge]: https://img.shields.io/github/license/health-informatics-uon/hutch-bunny.svg
[dotnet-badge]: https://img.shields.io/badge/.NET-5C2D91?style=for-the-badge&logo=.net&logoColor=white
[python-badge]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[docker-badge]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[docs-badge]: https://img.shields.io/badge/docs-black?style=for-the-badge&labelColor=%23222
[readme-badge]: https://img.shields.io/badge/readme-lightgrey?style=for-the-badge&labelColor=%23222
