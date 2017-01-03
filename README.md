# vax


Docker is great way to have immutable infrastructure. 

But sometimes you want to just hack on some ubuntu stuff without creating Dockerfile's
and remembering to commit changes. Something like vagrant up && vagrant ssh. Do you need 
entire Vagrant for that ? No. 

  vax init ubuntu:14.04
  vax run 
  root@9e8ab25a7c5e:/# apt-get update 
  root@9e8ab25a7c5e:/# apt-get install vim
  Ctrl+D
  
  sha256:eccbdaeb5a9a0ad3b7a32ba75f3b1455c5b7d4c3a880869aabb3520cfd92e707
  vax run 
  root@9e8ab25a7c5e:/# which vim
  /usr/bin/vim
  
  
After playing with the container, you changes are persistent. When you finish with your container, just drop it with:

  vax rm 
  
 

