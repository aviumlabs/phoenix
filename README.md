A Phoenix Framework Docker Image Repo
=====================================

This repo is designed as a template repo. The included prepare script will 
create a Phoenix Framework project without database support. 

Run `$ ./prepare -h` to get started.

The image is based on the Elixir Alpine docker image. 

Naming Convention
-----------------
This project currently only produces an Alpine based platform. No plans to 
change that for the time being.

The naming convention has been based on like projects, where Alpine is 
appended in the tag. Keeping that too. My conundrum is supporting the next
advances in Erlang and Elixir images while maintaining the current branch is 
not supported in my standard naming convention.

### Standard Naming Convention

    aviumlabs/phoenix:<version | latest>-alpine

### Possible Extended Naming Convention

    aviumlabs/phoenix:<version | latest>-elixir<version>-alpine
I think I'll start there and move forward.

Build Latest
------------
The image defaults to building the latest version of Phoenix Framework. As the 
image is based on Elixir Alpine it follows the naming convention of that 
project to indicate the Alpine Linux base.

    $ docker build --no-cache -t aviumlabs/phoenix:latest-alpine .
 
Build a Specific Version
------------------------
To build a specific version of the Phoenix Framework; pass in the Phoenix 
version you want to build: 


    $ export PHX_VERSION=1.7.1
    $ docker build -t aviumlabs/phoenix:$PHX_VERSION-alpine --build-arg \
    PHX_VERSION=$PHX_VERSION .

Companion Docker Compose Project
--------------------------------
There is a companion project to this project:

    https://github.com/aviumlabs/phoenix-compose.git

The aviumlabs/phoenix-compose repo is also a template repository. 

GitHub documentation for using a template repository is here:

    https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template

The services included are:
- PostgreSQL 15.3
- Phoenix Framework 1.7.3 or later

After creating a new repository from the template repository, you can get 
started with the prepare script:

    $ ./prepare -h 

Push Image to Docker Hub
------------------------

    $ docker push aviumlabs/phoenix:<tagname>
 
    $ docker push aviumlabs/phoenix:latest-alpine
    $ docker push aviumlabs/phoenix:1.7.3-alpine
