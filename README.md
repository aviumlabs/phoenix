# A Phoenix Framework Repo

This repo builds a Phoenix Framework docker image. 

The image is based on the Elixir Alpine docker image.   





## Recent Changes

Added __phoenix__ system account and set /opt/phoenix as the default 
container directory. 

The prepare script has been internalized and the functionality moved 
to the docker-entrypoint.sh file.

Running the container now depends on a couple of environment variables 
to be passed to the container.

APP_NAME - the name of the Phoenix application to be setup or run.
ECTO - a y/n flag (defaults to n) to include database support in the 
       Phoenix application

Ecto support in the docker-entrypoint script is designed to work with a docker 
compose project (see Companion Project below) to read the database secret from 
docker secrets.

Mix and hex are now installed under the /opt/phoenix directory.


Temporarily removed nodejs and npm due to incompatabilities between Phoenix 
v1.7.18 and Alpine 3.20. 


## Naming Convention

The naming convention is branched into **Standard** and **Extended** and is 
based on similar projects based on the Alpine Linux distribution, where 
`-alpine` is appended to the end of the tag.  


The **Standard** branch is based on the latest stable version of Elixir 
provided by the Elixir docker image.   

The **Extended** branch may either be based on the previous stable 
version of Elixir or the cutting edge version of Elixir.   


### Standard Naming Convention

    aviumlabs/phoenix:<version | latest>-alpine


Where version is either numeric based on the Phoenix version or the literal 
'latest'.  


### Extended Naming Convention
 
    aviumlabs/phoenix:<version | latest>-elixir<version>-alpine


## Build

The build is switched to include the Software Bill of Materials and Provenance attestations.


### Latest Phoenix Version 

This is the default - builds the latest version of Phoenix Framework.   

```shell
# regular build
docker build --no-cache -t aviumlabs/phoenix:latest-alpine .

# include sbom and provenance
docker build --no-cache -t aviumlabs/phoenix:latest-alpine --provenance=mode=max --sbom=true .
```


__Update the base image__

```shell
# regular build
docker build --pull --no-cache -t aviumlabs/phoenix:latest-alpine .

# include sbom and provenance
docker build --pull --no-cache -t aviumlabs/phoenix:latest-alpine --provenance=mode=max --sbom=true .
```

 
### Specific Phoenix Version

To build a specific version of the Phoenix Framework; pass in the Phoenix 
version you want to build:   


```shell
export PHX_VERSION=1.7.16

docker build --no-cache -t aviumlabs/phoenix:$PHX_VERSION-alpine \ 
--build-arg PHX_VERSION=$PHX_VERSION --provenance=mode=max --sbom=true .
```

## Run


Run the docker image and confirm alpine version, postgresql client version:

```shell
# Running Without Ecto
# Runs the container in the foreground
docker run --name app -it -e APP_NAME=app --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/app aviumlabs/phoenix:latest-alpine

# Running With Ecto - Will not work outside of docker compose
docker run --name app -it -e ECTO=y -e APP_NAME=app --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/app aviumlabs/phoenix:latest-alpine


# Open an additional shell 
cat /etc/alpine-release


>
> 3.20.5
>


    psql --version


> 
> psql (PostgreSQL) 16.6
> 
```

## Application Development

This docker image is designed to work with the host filesystem and the GitHub 
repository is a template repository.

To create your initial application development environment run the `gh repo create` 
command.

### Create and Clone a New Repository with GitHub CLI

General command
`gh repo create <application_name> -c -d "Application description" \
--private|--public -p aviumlabs/phoenix`


__Flags__

-c specifies to clone the repository to the current working directory
-d description of the new repository to be created
--private|--public specifies if this a private or public repository
-p make the new repository based on this template repository

```shell
# Example 
export APP_NAME=myapp
gh repo create $APP_NAME -c -d "My First Application" --private \
-p aviumlabs/phoenix
```

> 
> Created repository \<github\_userid\>myapp  on GitHub 
> Cloning into myapp...  
> 

The directory structure should now look like this:
* myapp
  * /src
* 

__References__
* https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template

---


## Companion Project


There is a companion project to this project for building a Phoenix Framework 
project integrated with PostgreSQL.  


    https://github.com/aviumlabs/phoenix-compose.git


The aviumlabs/phoenix-compose repo is also a template repository.   


The services included are:  
- PostgreSQL 16.6  
- Phoenix Framework 1.7.18 or later  


## Project Notes


### Project Testing




In a separate terminal session, confirm the application is running:  


    curl -X 'GET' http://localhost:4000

  
>
> \<!-- \<ApptestWeb.Layouts.root> lib/apptest\_web/components/layouts/root.html.heex:1 -->
> \<!DOCTYPE html>  
> \<html lang="en" class="[scrollbar-gutter:stable]">  
> \<head>  
> \<meta charset="utf-8">  
> \<meta name="viewport" content="width=device-width, initial-scale=1">  
> \<meta name="csrf-token" content="LT8sMxZVDDJOXDckWgEJOBsaCTF2cj5ffIYfA2CfziVuc2qTpnMp45w-">  
> \<title data-suffix=" · Phoenix Framework">  
> Apptest  
> · Phoenix Framework\</title>\<!-- \</Phoenix.Component.live\_title> -->  
> \<link phx-track-static rel="stylesheet" href="/assets/app.css">  
> \<script defer phx-track-static type="text/javascript" src="/assets/app.js">  
> \</script>  
> \</head>  
> \<body class="bg-white antialiased">  
> ...  
> \<iframe hidden height="0" width="0" src="/phoenix/live\_reload/frame">\</iframe>\</body>  
> \</html>\<!-- \</ApptestWeb.Layouts.root> -->
>  


Output from apptest runtime terminal:  

>
> [info] GET /  
> [debug] Processing with ApptestWeb.PageController.home/2  
>  Parameters: %{}  
>  Pipelines: [:browser]  
> [info] Sent 200 in 760µs  
>


Press ctrl-c a to stop running apptest  


## Application Testing


The Avium Labs Phoenix docker image includes the MIX\_ENV environment variable 
in the Dockerfile.   

`MIX_ENV=test`  

Run docker compose down/docker compose up to load the updated configuration and 
then run `mix test`.   

Change the MIX\_ENV setting back to `dev`, run docker compose down/up to go back 
to development mode.   


### Docker Hub


Internal notes for pushing images to Docker Hub.  


    docker push aviumlabs/phoenix:<tagname>-alpine  

 
    docker push aviumlabs/phoenix:latest-alpine  
