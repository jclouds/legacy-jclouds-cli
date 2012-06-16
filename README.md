jclouds-cli
===========

Jclouds CLI provides two types of command line interface:

* An interactive shell.
* A shell script.

Installation
-----------
To install the jclouds cli you just need to download the zip or the tarball and extract it to the folder of your choice.

Using the interactive shell
---------------------------
To start the interactive shell:
./bin/jclouds-cli


Using the script
----------------
To use the scirpt:
./bin/jclouds **[category]** **[action]** **[options]** **[arguments]**.

* *Categories*: node, group, image, location, hardware.
* *Actions*: list, create, destroy, runscript.
* *Options*: --provider, --identity, --credential --endpoint etc.

Some examples:
To create 10 nodes on EC2 under group: myGroupName using Ubuntu 10.04
<pre>
./jclouds node create --provider aws-ec2 --identity [identity] --credential [credential] --os-family ubuntu --os-version 10.04 --adminAcess myGroupName 10
</pre>

To list all nodes:
<pre>
./jclouds node list --provider aws-ec2 --identity [identity] --credential [credential]
</pre>

To destroy a node:
<pre>
./jclouds node destroy [node id]
</pre>




