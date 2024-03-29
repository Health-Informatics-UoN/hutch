---
sidebar_position: 3
---

# Running WfExS

For a full description of all functions offered by WfExS, refer to the README at [https://github.com/inab/WfExS-backend](https://github.com/inab/WfExS-backend).

To run a workflow using WfExS, first stage a workflow:
```shell
./WfExS_backend.py -L <path_to_wfexs_config.yaml> stage -W <stage_file.yaml>
```
This will prepare the workflow to run and provide a pithy random name to refer to when executing the workflow. If a nickname is provided in the stage file it will be added as a prefix to this.

To run the workflow use the following command:
```shell
./WfExS_backend.py -L <path_to_wfexs_config.yaml> staged-workdir offline-exec "pithy random name"
```

And finally, to package the workflow into an RO-Crate, which will include references to the inputs, outputs and workflows, run:
```shell
./WfExS_backend.py \
  -L <path_to_wfexs_config.yaml> \
  staged-workdir create-prov-crate "pithy random name" ROCrate.zip \
  --full
```

## Gotchas!

There are a few "gotchas" when running WfExS at the time of writing.

### Docker needing `sudo` to run
This can be fixed by following the [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user) for linux.

### `python-dxf` version 9.0.1
If needed force the downgrade of the python-dxf library by running:
```
pip install --force-reinstall python-dxf==9.0.1
```

### Correct workflow packing
WfExS defaults to using `cwltool` to run workflows, which in turn will be written using [Common Workflow Language](https://www.commonwl.org/user_guide/introduction/index.html). Currently there is a bug in `cwltool` which means that sometimes the workflow cannot be processed as expected by WfExS.

To get around this, it is best to write the workflow in 2 parts. The first part will be the the actual the command that will be run. See [here](https://raw.githubusercontent.com/inab/ipc_workflows/cosifer-20210322/cosifer/cwl/cosifer.cwl) for an example of this part. The second will be the actual workflow detailing the steps. See [here](https://raw.githubusercontent.com/inab/ipc_workflows/cosifer-20210322/cosifer/cwl/cosifer-workflow.cwl) for an example.

:::info Note the differences between the two links.
The first is an example of a `CommandLineTool` and says `CommandLineTool` in the `class` attribute of the file. Here the `baseCommand` and `inputs` are specified. In the `inputs` the flags for the command line tool are specified. The `outputs` capture the outputs of the command which can then be linked back to the workflow file. The second file is a `Workflow` with `Workflow` in the `class` attribute. This file specifies the `inputs` that will be passed to the steps in the `steps` array. It also lists the final `outputs` to be expected from the workflow. Each step in `steps` has a `run` attribute, which in this use case will be the path to `CommandLineTool` file, an `in` attribute mapping inputs from `inputs` to the step, and an `out` array linking back to the `outputs`.
:::
