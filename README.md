# Timebomb Chef example

This is a demonstration of using Chef to provision EC2 servers to run a fragile python app. It is intended to show an interesting example of _what_ is possible with Chef, but is not an example of _how_ to use Chef. I've intentionally taken many shortcuts to simply this example, which is not appropriate for production use.

## The python app

Timebomb is a fragile python app with a significant bug: sending a POST request to `/boom` will blow up the app server.

[timebomb.py](https://github.com/leknarf/timebomb/blob/master/timebomb.py)

## Launch


    spiceweasel --parallel timebomb_spice.yml | bash

## Open the HAProxy web console


    open http://`knife search node 'role:load_balancer' -a ec2.public_hostname |grep ec2.public_hostname | cut -f4 -d" "`:22002/


## Reload HAProxy


    knife ssh 'role:load_balancer' -a ec2.public_hostname -x ubuntu 'sudo chef-client'


## Hit one of the web servers


    curl http://`knife search node 'role:load_balancer' -a ec2.public_hostname |grep ec2.public_hostname | cut -f4 -d" "`

## Blow up a web server


    curl -X POST http://`knife search node 'role:load_balancer' -a ec2.public_hostname |grep ec2.public_hostname | cut -f4 -d" "`/boom

## Add a webserver


    spiceweasel timebomb_spice.yml | grep create | grep app | uniq | bash

## Cleanup


    spiceweasel -d timebomb_spice.yml | bash
    knife client bulk delete i-.\*

## Further reading

[Mike Fiedler](https://github.com/miketheman) has a much more elaborate chef example available at: [Full Stack](https://github.com/miketheman/fullstack/).

