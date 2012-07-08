jclouds-cli
===========

Jclouds CLI provides two types of command line interface:

* An interactive shell.
* A shell script.

Installation
-----------
To install the jclouds cli you just need to download the zip or the tarball and extract it to the folder of your choice.

Using the CLI
----------------
You can use the jclouds cli to perform misc operations, such as creating a node, run scripts on a node, list nodes, destroy a node etc.
The cli also supports blobstore, so you can create, delete or access a blobstore.

To use the cli:
./bin/jclouds **[category]** **[action]** **[options]** **[arguments]**.

* *Categories*: node, group, image, location, hardware.
* *Actions*: list, create, destroy, runscript.
* *Options*: --provider --api, --identity, --credential --endpoint etc.

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

APIs work in the same manner as providers, but you will also need to specify the endpoint.

Using the interactive shell
---------------------------
To start the interactive shell:
./bin/jclouds-cli

The are two ways of configuring a provider or api, when using the interactive mode:

* **As command options**
* **As a Service**

All commands support the following options that you can use: --provider (use this for apis too), --identity, --credential --endpoint.

For example, in a fresh installation you can simple:

<pre>
jclouds:node-list --provider [my provider or api] --identity [my identity] --credential [my credential] --endpoint [my endpoint]
</pre>

If you want to avoid passing the same options all the time, you can configure the provider or the api once and reuse it. To configure the provider or the api:

For compute providers & apis:

<pre>
config:edit org.jclouds.compute-[some id]
config:propset provider [my provider or api]
config:propset identity [my identity]
config:propset credential [my credential]
config:propset endpoint [my endpoint] **(this is only required for apis)**
config:update
</pre>

For blobstore providers or apis:

<pre>
config:edit org.jclouds.blobstore-[some id]
config:propset provider [my provider or api]
config:propset identity [my identity]
config:propset credential [my credential]
config:propset endpoint [my endpoint] **(this is only required for apis)**
config:update
</pre>

These commands, will create a new configuration with the filename specified as an argument. Each configuration will be assigned a new unique id, which you can use if you need to edit or delete the config in the future.

Once the service is configured, you can verify the service installation using:

<pre>
jclouds:compute-list **(for compute providers and apis)**
jclouds:blobstore-list **(for blobstore providers and apis)**
</pre>



Leveraging environmental variables
-----------------------------------
Both in the interactive shell and cli modes, you may find repeating the provider information again and again not really friendly.
You can completely skip those options by sepcifying them as environmental variables.

Supported variables:
* **JCLOUDS_COMPUTE_PROVIDER**
* **JCLOUDS_COMPUTE_API**
* **JCLOUDS_COMPUTE_ENDPOINT**
* **JCLOUDS_COMPUTE_IDENTITY**
* **JCLOUDS_COMPUTE_CREDENTIAL**

* **JCLOUDS_BLOBSTORE_PROVIDER**
* **JCLOUDS_BLOBSTORE_API**
* **JCLOUDS_BLOBSTORE_ENDPOINT**
* **JCLOUDS_BLOBSTORE_IDENTITY**
* **JCLOUDS_BLOBSTORE_CREDENTIAL**





