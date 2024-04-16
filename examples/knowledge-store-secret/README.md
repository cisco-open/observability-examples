# AWS Credentials Management Solution

This guide outlines the steps to deploy a solution package for securely managing
credentials within the Cisco
Observability Platform. The solution package includes a new knowledge type for
securely storing aws credentials and an
example Zodiac function and how to use the secret.

<!-- TOC -->
* [AWS Credentials Management Solution](#aws-credentials-management-solution)
  * [Learning Objectives](#learning-objectives)
  * [AWS Credentials Example overview](#aws-credentials-example-overview)
  * [Install required tools](#install-required-tools)
  * [Configure FSOC CLI](#configure-fsoc-cli)
  * [Solution structure](#solution-structure)
  * [Deploying Your Solution](#deploying-your-solution)
  * [Building your Zodiac function](#building-your-zodiac-function)
  * [Querying AWS Credentials](#querying-aws-credentials)
  * [Next Steps](#next-steps)
<!-- TOC -->

## Learning Objectives

By following this guide, you will learn how to use secrets in the Cisco
Observability Platform on the example of AWS
credentials. You will learn how to create a solution with AWS Credentials
Knowledge Store type, define access control,
a Nodejs zodiac function to use the AWS Credentials from the Knowledge Store and
IAM Permissions for access of the
Zodiac function REST API.

## AWS Credentials Example overview

One of the frquent requests from a customers of the Cisco Observability Platform
is to be able to bring their own AWS
credentials to be used by the zodiac functions. The platform provides a way to
securely store these secrets in the
Knowledge Store, define access control and use them from the zodiac functions.

This example folder includes

* AWS Credentials solution template to define AWS Credentials Knowledge Store
  type
* IAM Permissions with the Knowledge Store permissions and role mapping for the
  Knowledge Store type.
* Example of the knowledge object for the AWS Credentials
* Zodiac function with REST APIs to use the AWS Credentials from the Knowledge
  Store
* IAM Permissions for access of the Zodiac function REST API

The example also provides shell scripts to simplify copying and deploying the
solution to the Cisco Observability
Platform.

## Install required tools

Follow [fsoc cli installation guide](https://github.com/cisco-open/fsoc) to
install the FSOC CLI.

**Check FSOC CLI Installation and version**: 
```shell
fsoc version
```

if you need to upgrade to the newer fsoc version,
follow [fsoc installation doc](https://github.com/cisco-open/fsoc).



## Configure FSOC CLI

Set up your FSOC CLI to point to the Cisco Observability Platform and configure
your credentials.
```$ fsoc config set auth=oauth url=https://<mytenant>.observe.appdynamics.com```
The URL should point to your tenant.

Validate configuration

```$ fsoc login
Login completed successfully.
```

Refer to the [FSOC CLI documentation](https://github.com/cisco-open/fsoc) for
more options to configure the FSOC CLI.

## Solution structure

`package` is a directory that contains a template of the solution template

```shell
tree package
package
├── manifest.json
├── objects
│   ├── example
│   │   └── awscredsexample.json
│   ├── iam
│   │   ├── permissions
│   │   │   ├── aws-service-demo-permissions.json
│   │   │   └── awscreds-permissions.json
│   │   └── role-to-permissions-mappings
│   │       ├── aws-service-demo-role-to-permission-mappings.json
│   │       └── role-to-permission-mappings.json
│   └── zodiac
│       ├── egressHosts
│       │   └── aws-service-demo-egressHosts.json
│       └── functions
│           └── aws-service-demo.json
└── types
    └── awscreds.json
```

* `manifest.json` contains a solution manifest file that defines the solution
  name, version, and objects included
* `types` contains the definition of the knowledge type for the AWS Credentials
* `objects/iam` contains the IAM permissions and role mappings for the AWS
  Credentials
* `objects/zodiac` contains the zodiac function to demonstrate how to use the
  secrets
* `objects/example` contains an example of the knowledge object for the AWS
  Credentials

## Deploying Your Solution

Cisco Observability Platform is a multi-tenant platform, which makes it easy to
create and share solutions with other
users. You can easily publish your solution, but it has to have a unique name
and namespaces to ensure proper
isolation. The following scripts help to create a uniquely named soluition from
the template located in the `package`
folder and deploying it to the platform.

1. **Fork the Solution from the template**: Execute `fsoc solution fork --source-dir=package ${USER}awscreds -v` to create a copy
   of the solution `package` prefixed with
   your username. This process will also update various files within the
   solution with your username, preparing it for a
   personalized deployment.
2. **Check your solution**: The fork command creates your solution folder named `${USER}awscreds`.
3. **Define the Knowledge Type**: Review
   the `${USER}awscreds/types/awscreds.json` directory. This file defines the
   data type for securely storing database credentials within the Knowledge
   Store.
4. **Validate Your Solution**: Run `fsoc solution validate --directory ${USER}awscreds --tag=base -v` to check for any errors in
   your solution package.
5. **Deploy and Subscribe to the Solution**: Execute `fsoc solution push --directory ${USER}awscreds --tag=base` to deploy your
   solution to the Cisco Observability
   Platform. This script uses the FSOC CLI for deployment, subscription and
   waiting for the solution version to be
   installed.
6. **Subscribe your tenant to the solution**: `fsoc solution subscribe ${USER}awscreds --tag=base`
6. **Verify Deployment**: Utilize `fsoc solution status ${USER}malware --tag=base` to check the status of your
   solution deployment. Ensure that the
   solution name matches your `${USER}awscreds` and that the installation was
   successful.
7. **Add AWS Credentials Object**: Use the command below to add a knowledge
   object for your AWS Credentials. The
   provided `awscredsexample.json` file contains an example of the knowledge
   object you will create.

    ```shell
    fsoc knowledge create \ 
      --type=${USER}awscreds.base:awscreds \
      --layer-type=TENANT \ 
      --object-file=${USER}awscreds/objects/example/awscredsexample.json
    ```

## Building your Zodiac function

you can skip these steps and use a pre-built docker image from the public docker
registry. But these steps shows how to
build the docker image for the zodiac function. The function is a simple nodejs
function that fetches the AWS
credentials.

1. **Build the Zodiac function docker container**:

   ```shell
   export V=0.0.1 && docker build -t aws-service-demo ./ --tag zhirafovod/aws-service-demo:$V
   ```

2. Publish the docker image to the public docker registry:

   ```shell
   docker push zhirafovod/aws-service-demo:$V
   ```

3. **Point the Zodiac function to the right container**:
   change the image in
   the `package/objects/zodiac/functions/aws-service-demo.json` to point to the
   newly built docker
   image.

   ```json
   {
     "name": "awscreds-func",
     "image": "registry.hub.docker.com/zhirafovod/aws-service-demo:0.0.1",
     "scaleBounds": {
        "lower": 1,
        "upper": 1
     }
   }
   ```

4. Bump the version in `package/manifest.json` and repeat the steps to publish
   the solution.

## Querying AWS Credentials

1. **Query the Knowledge Type**: Use the FSOC CLI to retrieve the definition of
   your knowledge type:

    ```shell
    fsoc knowledge get-type --type "${USER}awscreds.base:awscreds"
    ```

2. **Create new Knowledge Object**: Add a new knowledge object for your database
   credentials using
   the `fsoc knowledge create` command.

   ```shell
    fsoc knowledge create --type=${USER}awscreds.base:awscreds \ 
      --layer-type=TENANT \ 
      --object-file=${USER}awscreds/objects/example/awscredsexample.json
    ```

   This will create a new knowledge object for your AWS Credentials.

3. **Fetch the object**: Use the `fsoc knowledge get` command to retrieve the
   knowledge object you created.

   ```shell
   fsoc knowledge get --type=${USER}awscreds.base:awscreds \ 
     --layer-type=TENANT --object-id=MY_AWS_ACCESS_KEY_ID
   
   createdAt: "2024-02-16T01:38:57.800Z"
   data:
   id: MY_AWS_ACCESS_KEY_ID
   key: '**********'
   region: us-west-2
   id: MY_AWS_ACCESS_KEY_ID
   layerId: 2d4866c4-0a45-41ec-a534-011e5f4d970a
   layerType: TENANT
   objectMimeType: application/json
   objectType: ${USER}awscreds.base:awscreds
   patch: null
   targetObjectId: null
   updatedAt: "2024-02-16T01:38:57.800Z"
   ```

   Notice that the password is masked with asterisks which indicates it is
   stored as a secret. The secret value can only
   be
   fetched from a zodiac function environment.

4. **Query the object from a zodiac function**
   Provided function fetches the AWS credentials from the knowledge store to
   show how the secrets can be used in a
   zodiac
   function.

   ```shell
   FSO_URL=https://<tenant>.saas.appd-test.com/rest/
   export TOKEN=`yq '.contexts[0].token' ~/.fsoc` ; curl -X POST -d \ 
     '{"id": "${USER}awscreds.base:awscreds/MY_AWS_ACCESS_KEY_ID"}' \ 
     --header "Authorization: Bearer $TOKEN" \ 
     -H 'Content-Type: application/json' \ 
     $FSO_URL/${USER}awscreds/${USER}awscreds-func -s | jq
   {
   "layerType": "TENANT",
   "id": "MY_AWS_ACCESS_KEY_ID",
   "layerId": "2d4866c4-0a45-41ec-a534-011e5f4d970a",
   "data": {
   "id": "MY_AWS_ACCESS_KEY_ID",
   "key": "MY_AWS_SECRET_ACCESS_KEY",
   "region": "us-west-2"
   },
   "objectMimeType": "application/json",
   "targetObjectId": null,
   "patch": null,
   "createdAt": "2024-02-16T01:38:57.800Z",
   "updatedAt": "2024-02-16T01:38:57.800Z",
   "objectType": "${USER}awscreds.base:awscreds"
   }
   ```

   Notice that the function could access the secret value of your AWS
   credentials.

   **Note**: The function above is using a token credential stoed in FSOC
   configuration file in `~/.fsoc` to
   authenticate to the
   platform. The token is used to make a request to the zodiac function REST
   API. If you have more than one profile in  
   `~/.fsoc` you may want to either export `TOKEN` manually or adjust array
   number in `yq '.contexts[0].token` command.

## Next Steps

Congratulations on deploying your AWS Credentials Management Solution! You've
learned more about Cisco Observability
Platform's Knowledge Store by following [developer
documentation](https://developer.cisco.com/docs/cisco-observability-platform/#!knowledge-store-introduction).
