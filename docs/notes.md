# Notes

The project currently only maintains one docker image: 
`aviumlabs/phoenix:latest-alpine`.

This image will always be the latest version of the complete 
Phoenix stack based on the current parent container. 

I.e., Erlang 27.x, Elixir 1.18.x, Phoenix 1.x.

The project currently uses `tags` to differentiate between parent 
containers. 

For development based on Elixir v1.17.x pull the v1.0.0.

For development based on Elixir v1.18.x pull the v1.1.0.
