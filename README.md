# docker-solargraph

https://github.com/coliver/docker-solargraph

# Solargraph VSCode Extension in Docker

I have a rails application that runs in a docker container which also contains the project's ruby environment.

I had a heck of a time getting Solargraph to work against the code in my container. Here's how I did it.

## Configure VSCode

Install the "Ruby Solargraph" extension

Install the "Remote Development" extension pack by Microsoft

In the "Remote Explorer" right click the docker container that has your project and choose Attach to Container

VSCode will open a new window, this is your remote dev window

In the newly opened remote dev window:

Click extensions in the side bar

Under 'Local - Installed' find Ruby Solargraph and click Install in container

A reload may be required, do that

Get back to the Remote Dev window

Open the Ruby Solargraph extension settings (gear icon)

Turn on all the options you want

Under 'Solargraph: External Server' click 'Edit in settings.json'

Add in:

```json
"solargraph.transport": "external",
"solargraph.externalServer": {
    "host": "docker-solargraph",
    "port": 7658
}
```

The host should be the name of your solargraph container which we will name shortly.

## Check the Dockerfile

Update the Solargraph version to the latest.

Latest Solargraph: https://github.com/castwide/solargraph/blob/master/lib/solargraph/version.rb

Use the Ruby version your project uses

Valid ruby versions here: https://hub.docker.com/_/ruby

## Build the image

If you don't need to specify a proxy (I did, I'm on a work vpn), remove the build-args below:

```shell
docker build --no-cache --build-arg HTTP_PROXY=$HTTP_PROXY --build-arg HTTPS_PROXY=$HTTPS_PROXY .
```

## Run and tag the container

Replace the strings in { } below.

```shell
docker run -d \
  --name=docker-solargraph \
  --net={Name of your projects docker network} \
  -p7878:7878 \
  -v {Full path to your project}:/app \
  cgoliver/docker-solargraph
```

## Enjoy Solargraph running in your container

Close and reopen VSCode or open the command palette and Reload Window / Reload Solargraph.

You can view the logs of the conatiner to debug if things aren't working at this point.
