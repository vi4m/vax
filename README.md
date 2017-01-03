# vax


Docker is great way to have immutable infrastructure. 

But sometimes you want to just hack on some ubuntu stuff without creating Dockerfile's
and remembering to commit changes. Something like vagrant up && vagrant ssh. Do you need 
entire Vagrant for that ? No. 

```
  vax init ubuntu:14.04
  
```

It creates .vax.toml 
```
image = "ubuntu:14.04"
temp_name = "temp"⏎                
```

Now you can "up" your container with

```
  vax run 
  root@9e8ab25a7c5e:/# apt-get update 
  root@9e8ab25a7c5e:/# apt-get install vim
  Ctrl+D
```

Your changes are persistent between sessions:
  
```
  vax run 
  root@9e8ab25a7c5e:/# which vim
  /usr/bin/vim
```
  
After playing with the container, you changes are persistent. When you finish with your container, just drop it with:

```
  vax rm 
```

