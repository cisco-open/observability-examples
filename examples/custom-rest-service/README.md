Our goal in this example is to provide step-by-step insructions for creating a solution that contains a custom REST endpoint. 

You will learn:

1. Create a service with a REST endpoint
1. Package the service inside a container image
1. Publish the container image to a container repository
1. Create a knowlege object to link your solution with the newly created image
1. Push the solution to the platform
1. Subscribe to the solution
1. Test the solution by invoking the new REST API with your platform credentials.

This tutorial requires the following tools:

- go
- docker
- fsoc
- yq
- curl

*this example requires at LEAST version 0.68 of `fsoc`*, make sure you have the
correct version.

```shell
fsoc version
```

if you need to upgrade to the newer fsoc version,
follow [fsoc installation doc](https://github.com/cisco-open/fsoc).


Create a simple REST service
---------------

The `service` folder contains the files for the service.
```text
├── Dockerfile
├── go.mod
└── main.go
```

`main.go` contains the minimal code to start a webserver on port 8080. Please remember, it is mandatory to run your http server on port 8080 to deploy on the COP platform.


Change to the service directory, build and run the application

```shell
cd service
go build
go run .
```
This should print
```shell
Starting server...
```


Packaging and publishing the image to a public container repository
---------------


Build and run the container image.
Please remeber to replace <GITHUB-USER-NAME> with your github username.

```shell
docker build -t  ghcr.io/<GITHUB-USER-NAME>/cop-examples/restdemo:latest .
docker run -t  ghcr.io/<GITHUB-USER-NAME>/cop-examples/restdemo:latest
```

Login to github  container respository. 

Generate an access token on github.com and substitute the <TOKEN> variable in the following command. Details on how to generate the token can be found here:

[How to Authenticate with the container registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry) 


```shell
 echo <TOKEN> | docker login ghcr.io -u <GITHUB-USER-NAME> --password-stdin
```


Push the image to the github registry or to any other public registry.

```shell
docker -v push  ghcr.io/<GITHUB-USER-NAME>/cop-examples/restdemo:latest
```

Creating the solution package
---------------

The `package` folder contains the files required to create the solution.

```text
├── manifest.json
└── objects
    └── function.json
```

Run the `fsoc solution fork` command, which creates a fork of the sample solution in the package directory, prefixed with your username. So if your local username is 'fred', fork.sh will make a local folder
named `fredrestdemo`. 
```shell
fsoc solution fork --source-dir=package ${USER}restdemo --verbose
```

Verify you have a folder whose name is `${USER}restdemo`


Edit the function.json file to use the image from your repository.

```json
{
    "name": "example1",
    "image": "ghcr.io/<GITHUB-USER-NAME>/cop-examples/restdemo:latest"
}
```

All REST apis require authorization. Configuration for read permissions for the new REST api is present in the file iam/permissions.

```json
[
    {
      "name": "restPermissions",
      "displayName":  "@INSTALL ${$sys.solutionId & ':restPermissions'}",
      "description": "rest api permissions",
      "actionAndResources": [{
        "action": {
          "method": "GET",
          "pathPattern": "/example1/hello/",
          "classification": "READ",
          "type": "HttpAction"
        }
      }]
    }
]
```

The file role-to-permission-mapping connects the perissions to specific roles granted to the user. Edit the iam/role-to-permission-mapping.json file to set the correct solution name

```json
[
    {
      "name": "restdemo",
      "roles": [
        "iam:observer",
        "iam:troubleshooter",
        "iam:configManager",
        "iam:tenantAdmin"
      ],
      "permissions": [
        {
          "id": "@INSTALL ${$sys.solutionId & ':restPermissions'}"
        }
      ]
    }
  ]
```


From the restdemo folder, use fsoc command to push the package to the plaform.

```shell
fsoc solution push --stable
```

 When successful this command should print the following message

 ```shell
 Successfully uploaded solution <USER-NAME>restdemo version 1.0.0 with tag stable.
 ``` 

 This will create a new REST api accesible with the scheme

```shell
https://<HOST>/rest/<SOLUTION-NAME>/<SERVICE-NAME>/*'

```

For this example, it will create two apis with URLs:

```shell
https://<TENANT-HOST-NAME>/rest/<USER-NAME>restdemo/example1/hello
https://<TENANT-HOST-NAME>/rest/<USER-NAME>restdemo/example1/headers

````

 Subscribe to the newly installed solution using fsoc command:
 ```shell
 fsoc solution subscribe <USER-NAME>restdemo
 ```

All custom REST endpoints requires authentication and authorization. 
The following commands uses the authentication token and platform URL from fsoc configuration file. 

Use curl to execute a GET request on the newly deployed service, and it should return a 200 response code with `hello` as the body

```shell
export TOKEN=`yq '.contexts[0].token' ~/.fsoc`
export URL=`yq '.contexts[0].url' ~/.fsoc`

curl -v --location "$URL/rest/<USER-NAME>restdemo/example1/hello" --header "Authorization: Bearer $TOKEN"
```
 When successful this command should print the following message


```shell
< HTTP/2 200
hello

```