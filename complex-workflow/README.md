# Complex Workflow
**Note:** Under development.

Performs several advanced CWL features for testing.

## How to run workflows

Assumes you are using the [datacommons-base](https://hub.docker.com/r/heliumdatacommons/datacommons-base/) Docker image.

Start an appliance using the instructions [here](https://github.com/heliumdatacommons/PIVOT/blob/master/examples/cwl.md).

### Toil execution
```
cwltoil --noLinkImports --jobStore /<path>/jobstore1 --batchSystem chronos --workDir ./ /<path>/<workflow>.cwl /<path>/<workflow-inputs>.yml
```

### Complex Workflow

Local execution:
```
$ cd workflows/complex-workflow/data
$ cwltool ../complex-workflow-1.cwl ../complex-workflow-1-job-local.yml
```

Will create `workflows/complex-workflow/data/test.tar` file with 8 files in the archive.
