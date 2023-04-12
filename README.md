A Phoenix Framework Docker Image Repo
=====================================

This repo is designed to be a template repo. The included prepare script will 
create a Phoenix Framework project without database support. 

Run `$ ./prepare -h` to get started.

The image is based on the Elixir Alpine docker image. 

Build Latest
------------
The image defaults to building the latest version of Phoenix Framework.

`
$ docker build -t aviumlabs/phoenix:latest-alpine .
`
 
Build a Specific Version
------------------------
To build a specific version of the Phoenix Framework; pass in the Phoenix 
version you want to build: 

`
$ export PHX_VERSION=1.7.1  
$ docker build -t aviumlabs/phoenix:$PHX_VERSION-alpine --build-arg \  
 PHX_VERSION=$PHX_VERSION .  
`
