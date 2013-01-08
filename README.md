jclouds-cli
===========
jclouds-cli is tool that allows you to interact with [jclouds](https://github.com/jclouds/jclouds) Compute, Blobstore and Chef services.
It is easy to use, configurable, extensible and it comes into 2 flavors:

* **An interactive shell**.
    * *Rich completion for commands, options and arguments*
    * *Reusability of services*
    * *Modularity and Extensibility*
* **A shell script**.
    * *Easily used from other scripts*.

Both flavors support reading configuration from environmental variables, so that you don't have to repeat the same options again and again.

Installation
------------
To install the jclouds cli you just need to download the zip or the tarball and extract it to the folder of your choice.

Using the CLI
-------------
You can use the jclouds cli to perform misc operations, such as creating a node, run scripts on a node, list nodes, destroy a node etc.
The cli also supports blobstore, so you can create, delete or access a blobstore.

Note that all cli invocations require parameters to be specified in the following order:

    **[category]** **[action]** **[options]** **[arguments]**

**Compute Service Usage**:

    ./bin/jclouds **[category]** **[action]** **[options]** **[arguments]**.

* *Categories*: node, group, image, location, hardware.
* *Actions*: list, create, destroy, runscript.
* *Options*: --provider --api, --identity, --credential, --endpoint etc.


**Compute Service Examples**:
To create 10 nodes on EC2 under group: myGroupName using Ubuntu 10.04

    ./jclouds node create --provider aws-ec2 --identity [identity] --credential [credential] --os-family ubuntu --os-version 10.04 --adminAccess myGroupName 10


To list all nodes:

    ./jclouds node list --provider aws-ec2 --identity [identity] --credential [credential]


To destroy a node:

    ./jclouds node destroy [node id]


**Blobstore Usage**:

    ./bin/jclouds **[category]** **[action]** **[options]** **[arguments]**.

* *Categories*: blobstore,
* *Actions*: list, create, destroy, read, write
* *Options*: --provider --api, --identity, --credential, --endpoint etc.


**Blobstore Examples**:
To create a container on S3:

    ./jclouds blobstore create --provider aws-s3 --identity [identity] --credential [credential] mycontainer

To list the content of container:

    ./jclouds blobstore list --provider aws-s3 --identity [identity] --credential [credential] mycontainer


To copy a file to a blob:

    ./jclouds blobstore list --provider aws-s3 --identity [identity] --credential [credential] mycontainer myblob /path/to/file

To copy using a url to a blob:

    ./jclouds blobstore list --provider aws-s3 --identity [identity] --credential [credential] mycontainer myblob myurl

To write a string value to a blob:

    ./jclouds blobstore list --provider aws-s3 --identity [identity] --credential [credential] --string-payload mycontainer myblob myvalue


APIs work in the same manner as providers, but you will also need to specify the endpoint.
**Chef Usage:**:

    ./bin/chef **[category]** **[action]** **[options]** **[arguments]**.

* *Categories*: cookbook, node group.
* *Actions*: list, bootstrap.
* *Options*: --api, --client-name, --client-key-file, --validator-name, --validator-key-file, --endpoint etc.

**Chef Examples:**:

To list all cookbooks:

    ./bin/chef cookbook list --client-name [client name] --client-key-file [path to client key file] --endpoint [endpoint]

To bootstrap an existing compute node:

    ./bin/chef node bootstrap --provider aws-ec2 --identity [identity] --credential [credential] --client-name [client name] --client-key-file [path to client key file] --endpoint [endpoint] [node id] [recipe]

To bootstrap an existing compute group:

    ./bin/chef group bootstrap --provider aws-ec2 --identity [identity] --credential [credential] --client-name [client name] --client-key-file [path to client key file] --endpoint [endpoint] [group id] [recipe]

To create a new compute node and apply a recipe:

    ./jclouds node create --provider aws-ec2 --identity [identity] --credential [credential] --recipe chef/myrecipe [node group]


Using the interactive shell
---------------------------
To start the interactive shell:
./bin/jclouds-cli

The interactive shell is a lightweight container powered by [Apache Karaf](http://karaf.apache.org) which is modular and extensible.
Out of the box it has installed support of Amazon EC2, Amazon S3 and Chef. But you can easily add or remove providers, apis, drivers etc using the features commands:

    features:list

Will list all the available features, that you can install. Some examples of adding additional features:

    features:install jclouds-api-cloudstack
    features:install jclouds-api-openstack-nova


All commands that are available from the script are also available in the interactive mode. The only difference is that in the interactive mode the **category** and **action** are encoded in the command name.
So all jclouds and chef commands follow the following format:

    scope:category-action [options] [arguments]

For example:

    jclouds:node-list --provider aws-ec2 --identity [identity] --credential [credential]
    jclouds:blobstore-list --provider aws-s3 --identity [identity] --credential [credential]
    chef:cookbook-list --client-name [client name] --client-key-file [path to client key file] --endpoint [endpoint]


One of the advantages of using the interactive shell is that it provides the ability to reuse services, and avoid the options boilerplate.

**Creating a reusable Compute Service**

    jclouds:compute-service-create --provider [provider] --identity [identity] --credential [credential] --name [service name]
    jclouds:compute-service-create --api [api] --identity [identity] --credential [credential] --endpoint [endpoint] --name [service name]

If no name option specified the provider or api will be used instead.
To list the available compute services:

    jclouds:compute-service-list

Here's an example output that list 2 services registered for the aws-ec2 provider. The service are named myec2 and yaec2:

    Compute APIs:
    -------------
    [id]                     [type]       [service]
    ec2                      compute      [ ]
    stub                     compute      [ ]


    Compute Providers:
    ------------------
    [id]                     [type]       [service]
    aws-ec2                  compute      [ myec2 yaec2 ]


Then you can reuse the service from the other commands with the following way:

    jclouds:node-list --name [service name]
    jclouds:node-create --name [service name]

Note that if there is only a single compute service available then the --name is optional. The same applies if there is a single service per api or provider. You can just specify the provider or the api and the shell will pick up the right service for you.
Recreating a service with the same name, will replace the the service. Finally you can destroy a service using the following command:

    jclouds:compute-service-destroy [serice name]

**Reusing Compute Services Examples**:
To create 10 nodes on EC2 under group: myGroupName using Ubuntu 10.04 and reusing myec2 service:

    jclouds:node-create --name myec2 --os-version 10.04 --adminAccess myGroupName 10


To list all nodes:

    jclouds:node-list --name myec2


To destroy a node:

    jclouds:node-destroy --name myec2


**Creating a reusable BlobStore Service**

    jclouds:blobstore-service-create --provider [provider] --identity [identity] --credential [credential] --name [service name]
    jclouds:blobstore-service-create --api [api] --identity [identity] --credential [credential] --endpoint [endpoint] --name [service name]

If no name option specified the provider or api will be used instead.
To list the available blobstore services:

    jclouds:blobstore-service-list

Here's an example output that list 2 services registered for the aws-s3 provider. The service are named mys3 and yas3:

    BlobStore APIs:
    -------------
    [id]                     [type]       [service]
    s3                       blobstore    [ ]
    transient                blobstore    [ ]


    BlobStore Providers:
    ------------------
    [id]                     [type]       [service]
    aws-ec2                  blobstore    [mys3 yas3]


Then you can reuse the service from the other commands with the following way:

    jclouds:blobstore-list --name [service name]
    jclouds:blobstore-write --name [service name]

Note that if there is only a single blobstore service available then the --name is optional. The same applies if there is a single service per api or provider. You can just specify the provider or the api and the shell will pick up the right service for you.
Recreating a service with the same name, will replace the the service. Finally you can destroy a service using the following command:

    jclouds:blobstore-service-destroy [serice name]

**Reusing BlobStore Services Examples**:
To create a container on S3 using service mys3:

    jclouds:blobstore-create --name mys3 mycontainer

To list the content of container:

    jclouds:blobstore-list --name mys3 mycontainer


To copy a file to a blob:

    jclouds:blobstore list ---name mys3 mycontainer myblob /path/to/file

To copy using a url to a blob:

    jclouds:blobstore-list --name mys3 mycontainer myblob myurl

To write a string value to a blob:

    jclouds:blobstore-list --name mys3 --string-payload mycontainer myblob myvalue

**Creating a reusable Chef Service**

    chef:service-create --api [api] --client-name [client name] --client-key-file [path to client key file] --endpoint [endpoint]

If no name option specified api will be used which defaults to "chef"..
To list the available chef services:

    chef:chef-service-list

Here's an example output that list 2 services registered for the aws-s3 provider. The service are named mys3 and yas3:

    Chef APIs:
    -------------
    [id]                     [type]       [service]
    chef                     chef         [mychef yachef]
    transient                chef         [ ]


Then you can reuse the service from the other commands with the following way:

    chef:cookbook-list --name [service name]

Note: In most cases, you'll only need a single service from the chef api, so it's usually pretty safe to skip --api or --name option.

    chef:service-destroy [serice name]

**Reusing Chef Services Examples**:
To list all cookbooks for the chef service named mychef:

    chef:cookbook-list --name mychef

To bootstrap an existing compute node that is managed by myec2 compute service *(here we are reusing 2 services in a single command)*:

    chef:node-bootstrap --name myec2 --chef-name mychef my-node-id java::openjdk

The same for an entire group:

    chef:node-bootstrap --name myec2 --chef-name mychef my-group java::openjdk

To create a new compute node and apply a recipe:

    jclouds:node-create --name mlycec2 --recipe mychef/myrecipe mygroup


Leveraging environmental variables
----------------------------------
Both in the interactive shell and cli modes, you may find repeating the provider information again and again not really friendly.
You can completely skip those options by specifying them as environmental variables.

For Compute Services:

* **JCLOUDS_COMPUTE_PROVIDER** The name of the compute provider.
* **JCLOUDS_COMPUTE_API** The name of the compute api.
* **JCLOUDS_COMPUTE_IDENTITY** The identity for accessing the compute provider.
* **JCLOUDS_COMPUTE_CREDENTIAL** The credential for accessing the compute provider.
* **JCLOUDS_COMPUTE_ENDPOINT** The endpoint (This is usually needed when using compute apis).
* **JCLOUDS_USER** The username of that will be used for accessing compute instances.
* **JCLOUDS_PASSWORD** The password that will be used for accessing compute instances.

For Blob Stores:

* **JCLOUDS_BLOBSTORE_PROVIDER** The name of the blobstore provider.
* **JCLOUDS_BLOBSTORE_API** The name of the blobstore api.
* **JCLOUDS_BLOBSTORE_IDENTITY** The identity for accessing the blobstore provider.
* **JCLOUDS_BLOBSTORE_CREDENTIAL** The credential for accessing the blobstore provider.
* **JCLOUDS_BLOBSTORE_ENDPOINT** The endpoint (This is usually needed when using blobstore apis).

For Chef:

* **JCLOUDS_CHEF_API** The name of the blobstore api.
* **JCLOUDS_CHEF_CLIENT_NAME** The client name.
* **JCLOUDS_CHEF_CLIENT_CREDENTIAL** The client credential.
* **JCLOUDS_CHEF_CLIENT_KEY_FILE** The path of the client key file (can be used instead of the above).
* **JCLOUDS_CHEF_VALIDATOR_NAME** The validator name.
* **JCLOUDS_CHEF_VALIDATOR_CREDENTIAL** The validator credential.
* **JCLOUDS_CHEF_VALIDATOR_KEY_FILE** The path of the validator key file (can be used instead of the above).
* **JCLOUDS_CHEF_ENDPOINT** The endpoint (This is usually needed when using chef apis).

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
To specify the headers of a command we need to place to specify the headers configuration as a semicolon separated list.
For hardware:


    hardware.headers=[id];[ram];[cpu];[cores]


**Defining the display data**
Display data are configured as a comma separated list of expressions (using the scripting engine of your choice, default is groovy). The expressions will be evaluated on the object of interest (in our example the hardware object).
To display the id field of the hardware object the expression to use is hardware.id. The reason for choosing groovy (as a default) for retrieving the data and not a simple expression language is that groovy is powerful and can be used for more complex expressions.
For example the Hardware object contains a collection of Processors and each processor has a filed of cores. To display the sum of cores among processors, we can use the following expression: hardware.processors.sum{it.cores}.

You can change the scripting engine:

    hardware.engine=groovy

Please note that if you don't specify the engine, then groovy will be assumed.

To specify the display data, now all you need to do is to provide the expressions:

    hardware.expressions=hardware.id;hardware.ram;hardware.processors.sum{it.cores*it.speed};hardware.processors.sum{it.cores}

The configuration above will display the hardware id in the first column, the hardware ram in the second column, the sum of cores X speed per processor in the third column and finally the sum of cores for all processors in the last column.

**Defining the sort order**
To specify the sort column, the sortBy option can be used to point to the header of the column of interest.
For example hardware hardware.sortby=[cpu].

**Changing the delimiter**
Most of the configuration options for the shell table are passed as delimited strings. What happens when you want to change the delimiter?
By default the delimiter is the semicolon symbol, but for each command category you can specify the delimiter. For example:


    hardware.delimiter=,
    hardware.headers=[id],[ram],[cpu],[cores]



See also
--------
* https://github.com/jclouds/jclouds/
* https://github.com/jclouds/jclouds-karaf/
* https://github.com/jclouds/jclouds-chef/






