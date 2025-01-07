![hutch-logo]

# 📤🐇 Hutch ![MIT License][license-badge]

**Hutch** is a suite of tools for **Federated Activities**, such as Analytics, Data Discovery or Machine Learning.

There are various Hutch tools for different use cases; this document should signpost to everywhere of interest, or you can [check out our docs][hutch-docs].

## HDR UK Cohort Discovery

There are [Hutch Cohort Discovery tools][cohort-discovery-repo] for working with the HDR UK Cohort Discovery Tool in various forms.

| Tool | Description | Links |
|-|-|-|
| **🐇 Bunny** | A drop-in replacement for BC\|Link | [![Bunny Docker Images][docker-badge]][bunny-containers] [![Bunny Docs][docs-badge]][bunny-docs] |
| **🔄 Relay** | A federated proxy; like a network splitter from one Cohort Discovery collection to many Bunnies | [![Relay Docker Images][docker-badge]][relay-containers] [![Relay Docs][docs-badge]][relay-docs] |
| **🔗 RQuest Bridge** | An integration between Cohort Discovery and the TRE-FX architecture | [![RQuest Bridge Docker Images][docker-badge]][bridge-containers] |

## GA4GH Beacon

We have developed Hutch implementations of the GA4GH Beacon API for targeting federated backends.

| Tool | Description | Links |
|-|-|-|
| **Hutch Beacon over TRE-FX** | A GA4GH Beacon API that submits to a Five Safes RO-Crate to the TRE-FX stack as a backend |  |
| **Hutch Beacon Worker** | A CLI tool to execute GA4GH Beacon queries against an OMOP-CDM database in PostgreSQL | |

## DARE UK TRE-FX

Hutch provided implementations for parts of the TRE-FX architecture, as well as workflow driven analysis capabilities for Cohort Discovery using the HDR UK Cohort Discovery Tool and GA4GH Beacon.

| Tool | Description | Links |
|-|-|-|
| **Hutch Controller** | A partial lightweight TRE-FX Controller implementation | [![Bunny Docker Images][docker-badge]][bunny-containers] [![Bunny Docs][docs-badge]][bunny-docs] |
| **Hutch Agent** | The primary TRE-FX Executing Agent implementation | [![Relay Docker Images][docker-badge]][relay-containers] [![Relay Docs][docs-badge]][relay-docs] |


## HDR UK Federated Analytics

We are actively working in the [HDR UK Federated Analytics programme][hdr-fa] and will be contributing open source tools and services [on GitHub][hdr-fa-repo].


[hutch-logo]: https://raw.githubusercontent.com/HDRUK/hutch/main/assets/Hutch%20splash%20bg.svg
[hutch-repo]: https://github.com/health-informatics-uon/hutch
[hutch-docs]: https://health-informatics-uon.github.io/hutch

[hdr-fa]: https://federated-analytics.ac.uk
[hdr-fa-repo]: https://github.com/federated-analytics

[cohort-discovery-repo]: https://github.com/Health-Informatics-UoN/hutch-cohort-discovery

[trefx-repo]: https://github.com/Health-Informatics-UoN/hutch-trefx

[bunny-docs]: https://health-informatics-uon.github.io/hutch/bunny
[bunny-containers]: https://github.com/Health-Informatics-UoN/hutch-cohort-discovery/pkgs/container/hutch%2Fbunny

[relay-docs]: https://health-informatics-uon.github.io/hutch/relay
[relay-containers]: https://github.com/Health-Informatics-UoN/hutch-cohort-discovery/pkgs/container/hutch%2Frelay

[bridge-containers]: https://hub.docker.com/r/hutchstack/rquest-bridge
[bridge-workflow]: https://workflowhub.eu/workflows/471

[rackit-packages]: https://github.com/Health-Informatics-UoN/hutch-cohort-discovery/pkgs/nuget/Hutch.Rackit
[rackit-readme]: https://github.com/Health-Informatics-UoN/hutch-cohort-discovery/blob/main/lib/Hutch.Rackit/README.md

[5s-crate]: https://trefx.uk/5s-crate/

[license-badge]: https://img.shields.io/github/license/health-informatics-uon/hutch-cohort-discovery.svg
[dotnet-badge]: https://img.shields.io/badge/.NET-5C2D91?style=for-the-badge&logo=.net&logoColor=white
[python-badge]: https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white
[docker-badge]: https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white
[docs-badge]: https://img.shields.io/badge/docs-black?style=for-the-badge&labelColor=%23222
[readme-badge]: https://img.shields.io/badge/readme-lightgrey?style=for-the-badge&labelColor=%23222