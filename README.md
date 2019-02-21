$ docker build . -t web                                                                                                                             
$ docker run --network host -p 8443:443 -v /var/www/html/cernbox/:/var/www/html/cernbox -d web

