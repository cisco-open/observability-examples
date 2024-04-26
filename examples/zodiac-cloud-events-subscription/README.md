# Zodiac Cloud Events Subscription Solution

This example previews Cisco Observability Platform Zodiac function that can be
subscribed to objects creation cloud events of the solution-defined Knowledge
Store Types.

<!-- TOC -->
* [Zodiac Cloud Events Subscription Solution](#zodiac-cloud-events-subscription-solution)
  * [Learning Objectives](#learning-objectives)
  * [](#)
<!-- TOC -->

## Learning Objectives

By following this guide, you will learn how to define Knowledge Store types,
Zodiac function, Cloud Events Subscription, and IAM permissions needed for the
solution. You will also learn how to deploy the solution to the Cisco
Observability Platform and how to use the solution.

## Example overview

The example uses [stated-workflow](https://github.com/cisco-open/stated-workflow) to demonstrate how a Zodiac function can 
be subscribed to objects of Event and Workflow types.

Workflow type defines a stated workflow, and event type represents a cloud event
that triggers the workflow.

## Prerequisites
Install [Prerequisites](https://github.com/cisco-open/observability-examples#Prerequisites).

## Solution structure

`package` is a directory that contains a template of the solution template

```shell
package/
├── manifest.json
├── objects
│   ├── example
│   │   ├── example-event.json
│   │   └── example-workflow.json
│   ├── iam
│   │   ├── eventTypePermissions.json
│   │   ├── roleToPermissionMappings.json
│   │   ├── workflowTypePermissions.json
│   │   └── zodiacPermissions.json
│   └── zodiac
│       ├── egressHosts.json
│       ├── eventSubscription.json
│       ├── function.json
│       └── workflowSubscription.json
└── types
    ├── event.json
    └── workflow.json
```
* `manifest.json` contains a solution manifest file that defines the solution
  name, version, objects and types included
* `types` directory contains the definition of the Knowledge Store types
* `objects/iam` contains the IAM permissions and role mappings for types and zodiac function
* `objects/zodiac` contains the zodiac function to demonstrate how to use the
  secrets
* `objects/example` contains an example of the knowledge object for the AWS
  Credentials

## Deploying Your Solution
Cisco Observability Platform is a multi-tenant platform, which makes it easy to
create and share solutions with other
users. You can easily publish your solution, but it has to have a unique name
and namespaces to ensure proper
isolation. The following commands create a uniquely named soluition from
the template located in the `package`
folder and deploying it to the platform.

1. **Fork the Solution from the template**:
   Execute `fsoc solution fork --source-dir=package ${USER}workflow -v` to
   create a copy
   of the solution `package` prefixed with
   your username. This process will also update various files within the
   solution with your username, preparing it for a
   personalized deployment.
2. **Check your solution**: The fork command creates your solution folder
   named `${USER}workflow`.
3. **Define the Knowledge Type**: Review
   the `${USER}workflow/types/workflow.json` directory. This file defines the
   data type for securely storing database credentials within the Knowledge
   Store.
4. **Validate Your Solution**:
   Run `fsoc solution validate --directory ${USER}workflow --tag=stable -v` to
   check for any errors in
   your solution package.
5. **Deploy and Subscribe to the Solution**:
   Execute `fsoc solution push --directory ${USER}workflow --tag=stable` to deploy
   your
   solution to the Cisco Observability
   Platform. This script uses the FSOC CLI for deployment, subscription and
   waiting for the solution version to be
   installed.
6. **Subscribe your tenant to the solution
   **: `fsoc solution subscribe ${USER}workflow --tag=stable`
7. **Verify Deployment**:
   Utilize `fsoc solution status ${USER}malware --tag=stable` to check the status
   of your
   solution deployment. Ensure that the
   solution name matches your `${USER}workflow` and that the installation was
   successful. 
8. **Create Workflow Object**: Use the command below to add a knowledge
   object for your AWS Credentials. The
   provided `workflow.json` object file contains an example of stated workflow.
   ```shell
   fsoc knowledge create \ 
      --type=${USER}workflow:workflow \
      --layer-type=TENANT \ 
      --object-file=${USER}workflow/objects/example/workflow.json
    ```
9. **Create Event Object**: Use the command below to add a knowledge object
   for your AWS Credentials. The
   provided `event.json` object file contains an example of stated workflow.
   ```shell
   fsoc knowledge create \ 
      --type=${USER}workflow:event \
      --layer-type=TENANT \ 
      --object-file=${USER}workflow/objects/example/event.json
    ```

