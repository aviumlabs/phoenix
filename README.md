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


* APP_NAME - the name of the Phoenix application to be setup or run.
* ECTO - a y/n flag (defaults to n) to include database support in the 
       Phoenix application


Ecto support in the docker-entrypoint script is designed to work with the docker 
phoenix-compose project (see Companion Project below).


Mix and hex are now installed under the /opt/phoenix directory.


## Image Naming Convention


The image naming convention is divided between **Standard** and **Extended**.
It is based on similar projects running Alpine Linux, where `-alpine` is 
appended to the end of the tag.  


The **Standard** naming convention will attempt to be based on the latest 
version of Alpine, Erlang, Elixir, and the Phoenix Framework except in the 
case of where a conflict arises.  


The **Extended** naming convention may either be based on the previous stable 
version of Elixir or the cutting edge version of Elixir.   


### Standard Naming Convention

    aviumlabs/phoenix:<version | latest>-alpine


Where version is either numeric based on the Phoenix version or the literal 
'latest'.  


### Extended Naming Convention
 
    aviumlabs/phoenix:<version | latest>-elixir<version>-alpine


## Building an Image


### Latest Phoenix Version 

This is the default - builds the latest version of Phoenix Framework.   

```shell
# regular build
docker build --no-cache -t aviumlabs/phoenix:latest-alpine .

# include sbom and provenance
docker build --no-cache -t aviumlabs/phoenix:latest-alpine --provenance=mode=max --sbom=true .
```


__Update the Base Image__


```shell
# regular build
docker build --pull --no-cache -t aviumlabs/phoenix:latest-alpine .

# include sbom and provenance
docker build --pull --no-cache -t aviumlabs/phoenix:latest-alpine --provenance=mode=max --sbom=true .
```

 
### Specific Phoenix Version


To build a specific version of Phoenix Framework; pass in the Phoenix 
version you want to build:   


```shell
export PHX_VERSION=1.7.20

# replace aviumlabs with your docker namespace
docker build --no-cache -t aviumlabs/phoenix:$PHX_VERSION-alpine \ 
--build-arg PHX_VERSION=$PHX_VERSION --provenance=mode=max --sbom=true .
```

## Run


Run the docker image and confirm Alpine version, PostgreSQL client version:

```shell
# Running Without Ecto
# Runs the container in the foreground
docker run --name app -it -e APP_NAME=app --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/app aviumlabs/phoenix:latest-alpine

# Running With Ecto - Will not work outside of docker compose
docker run --name app -it -e ECTO=y -e APP_NAME=app --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/app aviumlabs/phoenix:latest-alpine

docker run --name myapp -it -e ECTO=y -e APP_NAME=myapp --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/app aviumlabs/phoenix:latest-alpine

# Open an additional shell 
cat /etc/alpine-release

>
> 3.21.3
>

psql --version

> 
> psql (PostgreSQL) 17.4
> 
```

## Application Development

This docker image is designed to work with the host filesystem and the GitHub 
repository is a template repository.


To create your initial application development environment run the 
`gh repo create` command.


### Create and Clone a New Repository with GitHub CLI

General command


`gh repo create <application_name> -c -d "Application description" \
--private|--public -p aviumlabs/phoenix`


__Flags__

* -c specifies to clone the repository to the current working directory
* -d description of the new repository to be created
* --private|--public specifies if this a private or public repository
* -p make the new repository based on this template repository

```shell
# Example 
gh repo create myapp -c -d "My First Application" --private \
-p aviumlabs/phoenix
```

> 
> Created repository \<github\_userid\>/myapp  on GitHub 
> https://github.com/\<github\_userid\>/myapp
> Cloning into myapp...  
> 

The directory structure will now look like this:
* myapp
  * /src
  * /docs
    * /images
    * /pdf
* Dockerfile
* LICENSE
* README.md
* docker-entrypoint.sh

During the first-time run, the application will be configured, and the src 
directory will be populated with the baseline Phoenix Framwork application.

```shell
docker run --name myapp -it -e APP_NAME=myapp --rm -p 4000:4000 --mount type=bind,src="$(pwd)/src",target=/opt/phoenix/myapp aviumlabs/phoenix:latest-alpine 

> 
> Generated myapp app
> [info] Running MyappWeb.Endpoint with Bandit 1.6.7 at 0.0.0.0:4000 (http)
> [info] Access MyappWeb.Endpoint at http://localhost:4000
> [watch] build finished, watching for changes...
> 
> Rebuilding...
> 
> Done in 740ms.
> 
```

Browsing to http://localhost:4000 will show you the default landing page of a 
Phoenix Framework application.


And listing the contents of src directory will show you the standard Phoenix 
Framework application layout.


* README.md
* assets
* deps
* _build
* config 
* lib
* mix.exs
* mix.lock
* priv
* test

As a development environment, live\_reload is active. 

Edit src/lib/my_webapp/controllers/page_html/home.html.eex

Search for Phoenix Framework and insert some text like 
MyApp powered by Phoenix Framework.

Save the file and go back to your browser and you will automatically see 
the change. 

Pretty awesome! Much gratitude and appreciation to the Phoenix Framework, 
Elixir, Erlang, Alpine, and PostgreSQL teams for their amazing work!


From here it is up to you to build some amazing applications. Good luck!
 

__References__
* https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template

---


## Companion Project


There is a companion project to this project for building a Phoenix Framework 
project integrated with PostgreSQL.  


    https://github.com/aviumlabs/phoenix-compose.git


The aviumlabs/phoenix-compose repo is also a template repository.   


The services included are:  
- PostgreSQL 17.4 
- Phoenix Framework 1.7.20 or later  


## Project Notes


### Project Testing


In a separate terminal session, confirm the application is running:  


    curl -X 'GET' http://localhost:4000

  
>
> <!-- \<AppWeb.Layouts.root> lib/app_web/components/layouts/root.html.heex:1 -->  
> <!DOCTYPE html>  
> <html lang="en" class="[scrollbar-gutter:stable]">  
> <head>  
> <meta charset="utf-8">  
> <meta name="viewport" content="width=device-width, initial-scale=1">  
> ...  
> <title data-default="App" data-suffix=" · Phoenix Framework"> ...  
> <iframe hidden height="0" width="0" src="/phoenix/live\_reload/frame">\</iframe>\</body>  
> </html>\<!-- \</AppWeb.Layouts.root> -->
>  


Output from app runtime terminal:  

>
> [info] GET /  
> [debug] Processing with AppWeb.PageController.home/2  
>  Parameters: %{}  
>  Pipelines: [:browser]  
> [info] Sent 200 in 760µs  
>


Press ctrl-c a to stop running app    


### Docker Hub


Internal notes for pushing images to Docker Hub.  


    docker push aviumlabs/phoenix:<tagname>-alpine  

 
    docker push aviumlabs/phoenix:latest-alpine  