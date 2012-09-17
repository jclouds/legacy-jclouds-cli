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


    jclouds:node-list --provider [my provider or api] --identity [my identity] --credential [my credential] --endpoint [my endpoint]


If you want to avoid passing the same options all the time, you can configure the provider or the api once and reuse it. To configure the provider or the api:

For compute providers & apis:

    jclouds:compute-service-create --provider [provider] --identity [identity] --credential [credential]


    jclouds:compute-service-create --api [api] --identity [identity] --credential [credential] --endpoint [endpoint]


For blobstore providers or apis:


    jclouds:blobstore-service-create --provider [provider] --identity [identity] --credential [credential]


    jclouds:blobstore-service-create --api [api] --identity [identity] --credential [credential] --endpoint [endpoint]


To list the available compute or blobstore services:


    jclouds:compute-service-list (for compute providers and apis)
    jclouds:blobstore-service-list (for blobstore providers and apis)


You can also remove one of the services:


    jclouds:compute-service-destroy --provider [provider]
    jclouds:blobstore-service-destroy --provider [provider]


**Installing additional providers and api**
The interactive version of the cli will have out of the box installed support for the mainstream providers and apis. To enable the any other provider or api, you will need to enable it.
This is done using the features commands.

List the available jclouds modules:

    features:list


To install an additional api *(say cloudstack)*

    features:install jclouds-api-cloudstack



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

Configuring command output
--------------------------
As of jclouds-cli version 1.5.0 commands support output customization. The customization features are:

* **Width calculation** The commands calculate the required column width and adjust the format accordingly.
* **Configurable columns** Can add remove columns using configuration.
* **Groovy value retrieval** The display content is configurable using groovy expressions.
* **Configurable column alignment** You can configure for each column left or right alignment.
* **Configurable sorting options** Configure ordering by column using ascending or descending order.

The configuration for all columns can be found inside the org.jclouds.shell pid. Each configuration key is prefixed using the command category (node, image, location, hardware etc).
The suffix defines the configuration topic. For example hardware.headers defines the headers to be displayed by the hardware commands.
In the following commands the hardware category will be used as example.

**Defining the command headers**
To specify the headers of a command we need to place to specify the headers configuration as a semicoln separated list.
For hardware:


    hardware.headers=[id];[ram];[cpu];[cores]


**Defining the display data**
Display data are configured as a comma separated list of expressions (using the scripting engine of your choice, default is groovy). The expressions will be evaluated on the object of interest (in our example the hardware object).
To display the id field of the hardware object the expression to use is hardware.id. The reason for choosing groovy (as a default) for retrieving the data and not a simple expression language is that groovy is powerfull and can be used for more complex expressions.
For example the Hardware object contains a collection of Processors and each processor has a filed of cores. To display the sum of cores among processors, we can use the following expression: hardware.processors.sum{it.cores}.

You can change the scripting engine:

    hardware.engine=groovy

Please note that if you don't specify the engine, then groovy will be assumed.

To specify the display data, now all you need to do is to provide the expressions:

    hardware.expressions=hardware.id;hardware.ram;hardware.processors.sum{it.cores*it.speed};hardware.processors.sum{it.cores}

The configuration above will display the hardware id in the first column, the hardware ram in the second column, the sum of cores X speed per processor in the third column and finally the sum of cores for all processors in the last column.

**Defining the sort order**
To specify the sort column, the sortBy option can be used to point to the header of the column of interest.
For example hardware hardware.shortby=[cpu].

**Changing the delimeter**
Most of the configuration options for the shell table are passed as delimited strings. What happens when you want to change the delimiter?
By default the delimeter is the semicoln symbol, but for each command category you can specify the delimiter. For example:


    hardware.delimeter=,
    hardware.headers=[id],[ram],[cpu],[cores]



See also
--------
https://github.com/jclouds/jclouds/
https://github.com/jclouds/jclouds-karaf/






