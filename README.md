<p align="center">
  <picture>
    <img alt="Hutch Logo" src="https://raw.githubusercontent.com/Health-Informatics-UoN/hutch/refs/heads/main/website/public/images/hutch-logo-colour.svg" width="280"/>
  </picture>
</p>
<div align="center">
  <strong>
  Hutch is a toolset for Federated Activities, such as Analytics, Data Discovery, or Machine Learning.
  </strong>
</div>

## Hutch-TREFX

![MIT License][license-badge] [![Trefx Repo][github-badge]][trefx-repo] [![Trefx Releases][trefx-releases-badge]][trefx-releases] [![Trefx Tests][trefx-tests-badge]][trefx-tests]

![.NET][dotnet-badge] [![Trefx Docs][docs-badge]][trefx-docs]

[Hutch-TREFX][trefx-repo] is an Executing Agent implementation that accepts jobs from a TRE Agent, executes them and records outputs and provenance, submitting the results to be approved for egress.

## Cohort Discovery

### 🐇 [Bunny][bunny-repo]

![MIT License][license-badge] [![Bunny Repo][github-badge]][bunny-repo] [![Bunny Releases][bunny-releases-badge]][bunny-releases] [![Bunny Tests][bunny-tests-badge]][bunny-tests]

![Python][python-badge] [![Bunny Docker Images][docker-badge]][bunny-containers] [![Bunny Docs][docs-badge]][bunny-docs] [![Bunny Roadmap][roadmap-badge]][roadmap]

A Cohort Discovery Task Resolver.

Fetches and resolves Availability and Distribution Queries against a PostgreSQL OMOP CDM database.

### 🔄 [Relay][relay-repo]

[![MIT License][license-badge]][license-badge] [![Relay Repo][github-badge]][relay-repo] [![Relay Releases][relay-releases-badge]][relay-releases] [![Relay Tests][relay-tests-badge]][relay-tests]

![.NET][dotnet-badge] [![Relay Docker Images][docker-badge]][relay-containers] [![Relay Docs][docs-badge]][relay-docs] [![Relay Roadmap][roadmap-badge]][roadmap]

A Federated Proxy for a Cohort Discovery Task API.

- Connects to an upstream Task API (e.g. the HDR UK Cohort Discovery Tool).
- Fetches tasks.
- Queues them for one or more downstream sub nodes (e.g. Bunny instances).
- Accepts task results from the downstream nodes.
- Submits aggregate results to the upstream Task API.
- Implements a subset of the Task API for the downstream nodes to interact with.

[hutch-logo]: https://raw.githubusercontent.com/HDRUK/hutch/main/assets/Hutch%20splash%20bg.svg
[roadmap]: https://github.com/orgs/Health-Informatics-UoN/projects/1/views/15
[bunny-repo]: https://github.com/Health-Informatics-UoN/hutch-bunny
[bunny-docs]: https://hutch.health/bunny
[bunny-containers]: https://github.com/Health-Informatics-UoN/hutch-bunny/pkgs/container/hutch%2Fbunny
[bunny-releases]: https://github.com/Health-Informatics-UoN/hutch-bunny/releases
[bunny-tests]: https://github.com/Health-Informatics-UoN/hutch-bunny/actions/workflows/check.run-tests.yml
[bunny-releases-badge]: https://img.shields.io/github/v/tag/Health-Informatics-UoN/hutch-bunny
[bunny-tests-badge]: https://github.com/Health-Informatics-UoN/hutch-bunny/actions/workflows/check.run-tests.yml/badge.svg
[relay-repo]: https://github.com/Health-Informatics-UoN/hutch-relay
[relay-docs]: https://hutch.health/relay
[relay-containers]: https://github.com/Health-Informatics-UoN/hutch-relay/pkgs/container/hutch%2Frelay
[relay-releases]: https://github.com/Health-Informatics-UoN/hutch-relay/releases
[relay-tests]: https://github.com/Health-Informatics-UoN/hutch-relay/actions/workflows/check.relay.build-test.yml
[relay-releases-badge]: https://img.shields.io/github/v/tag/Health-Informatics-UoN/hutch-relay
[relay-tests-badge]: https://github.com/Health-Informatics-UoN/hutch-relay/actions/workflows/check.relay.build-test.yml/badge.svg
[trefx-repo]: https://github.com/Health-Informatics-UoN/hutch-trefx
[trefx-docs]: https://health-informatics-uon.github.io/hutch-trefx/
[trefx-releases]: https://github.com/Health-Informatics-UoN/hutch-trefx/releases
[trefx-releases-badge]: https://img.shields.io/github/v/tag/Health-Informatics-UoN/hutch-trefx
[trefx-tests]: https://github.com/Health-Informatics-UoN/hutch-trefx/actions/workflows/build.HutchAgent.yml
[trefx-tests-badge]: https://github.com/Health-Informatics-UoN/hutch-trefx/actions/workflows/build.HutchAgent.yml/badge.svg
[license-badge]: https://img.shields.io/github/license/health-informatics-uon/hutch-bunny.svg
[dotnet-badge]: https://img.shields.io/badge/.NET-5C2D91?style=flat-square&logo=.net&logoColor=white
[python-badge]: https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white
[docker-badge]: https://img.shields.io/badge/docker-%230db7ed.svg?style=flat-square&logo=docker&logoColor=white
[docs-badge]: https://img.shields.io/badge/docs-black?style=flat-square&labelColor=%23222
[roadmap-badge]: https://img.shields.io/badge/roadmap-blue?style=flat-square&labelColor=%230066cc
[github-badge]: https://img.shields.io/badge/github-black?style=flat-square&logo=github&logoColor=white
