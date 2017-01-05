# vax

Vax allows you to work on set of virtualmachines using only Docker. When using Docker on OSX it is much faster, easy on resources, than Vagrant. 


## But ... docker want's to be immutable?

In production - yes. But during development, you often want to just hack on some ubuntu stuff without creating Dockerfile's just to be erased after docker exit. Missing Vagrant like vagrant up && vagrant ssh ? Vax to the rescue.

## How does it work?

Vax is just a simple wrapper to `docker run` +  `docker commit` during development which takes care of keeping images in order.


```
  vax init ubuntu:14.04 hacking
  
```

It creates .vax.toml in current directory
```
source_image = "ubuntu:14.04"
dest_image = "hacking"
temp_name = "temp_hacking"    
```

Now you can "up" your container with

```
  vax run 
  root@9e8ab25a7c5e:/# apt-get update 
  root@9e8ab25a7c5e:/# apt-get install vim
  Ctrl+D
```
Ater exit, your changes *will* be commited. So you can resume your hackig session at any time, from within this directory. 
Just as in vagrant, you can resume this "vm" with : 
  
```
  vax run 
  root@9e8ab25a7c5e:/# which vim
  /usr/bin/vim
```
  
