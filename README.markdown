# Official Docker Image Build Project

This project is used to build Liferay Docker images for both Community Edition 
and DXP. Liferay Commerce Docker images are also built through this project.

The respective official Docker Hub repositories are:

1. [Official images for Liferay DXP releases](https://hub.docker.com/r/liferay/dxp)
2. [Official images for Liferay Portal releases](https://hub.docker.com/r/liferay/portal)
3. [Official images for Liferay Commerce Enterprise releases](https://hub.docker.com/r/liferay/commerce-enterprise)
4. [Official images for Liferay Commerce releases](https://hub.docker.com/r/liferay/commerce)

The project was born to build Liferay images based exclusively on the Tomcat bundle.

This fork, born from the [Liferay Docker](https://github.com/liferay/liferay-docker) repository, 
adds the ability to build Liferay local Docker images based on JBoss EAP.

## 1. Requirements
@TODO: To be complete

## 2. How to build local Docker images
Using the build_local_image.sh command, you can build your own local Liferay 
Docker images. By default, the images are created using the Liferay Tomcat bundle.

The command has the following usage forms:

```bash
Usage: ./build_local_image.sh path-to-bundle image-name version [push] [application server]

Example:
	 1. Build docker image from Liferay Tomcat Bundle
		 ./build_local_image.sh ../bundles/master portal-snapshot demo-cbe09fb0
	 2. Build docker image from Liferay Tomcat Bundle with push the image
		 ./build_local_image.sh ../bundles/master portal-snapshot demo-cbe09fb0 push
	 3. Build docker image Liferay with JBoss EAP Bundle without push the image
		 ./build_local_image.sh ../../bundles/ portal-snapshot liferay72-dxp-dev no-push jboss-eap
	 4. Build docker image Liferay with JBoss EAP Bundle with push the image
		 ./build_local_image.sh ../../bundles/ portal-snapshot liferay72-dxp-dev push jboss-eap
```

The first two commands build the Docker image starting from the Liferay Tomcat 
bundle, in particular, the second command also pushes to the Docker repository.

The last two commands instead build the Docker image using JBoss EAP as 
application server, in particular, the second command also pushes the image to 
the Docker repository.

### 2.1 How to build a Liferay local Docker image based on JBoss EAP
Before running the build image command, the following requirements must be met.
The image creation process refers to the documentation [Installing on JBoss EAP](https://learn.liferay.com/dxp/7.x/en/installation-and-upgrades/installing-liferay/installing-liferay-on-an-application-server/installing-on-jboss-eap.html).

Installing on JBoss EAP requires deploying dependencies, modifying scripts, 
modifying config xml files, and deploying the DXP WAR file. 

Liferay DXP requires Java JDK 8 or 11. See the compatibility matrix for further 
information.

Download these files from the Liferay Help Center (subscription) or from 
Liferay Community Downloads and RedHat Customer Portal

1. DXP WAR file
2. Dependencies ZIP file
3. OSGi Dependencies ZIP file
4. JBoss EAP ZIP file

Note that Liferay Home is the folder containing the JBoss server folder. 
After installing and deploying DXP, the Liferay Home folder contains the 
JBoss server folder as well as data, deploy, logs, and osgi folders. 
$JBOSS_HOME refers to the JBoss server folder.

Once the four files have been downloaded, you can proceed with the image build.
The files needed to build the Liferay DXP 7.2 image on JBoss EAP 7.2 GA are 
shown below.

```bash
jboss-eap-7.2.0.zip
liferay-dxp-dependencies-7.2.10.3-sp3-202009100727.zip
liferay-dxp-osgi-7.2.10.3-sp3-202009100727.zip
liferay-dxp-7.2.10.3-sp3-202009100727.war
```

It is not necessary that the downloaded files are necessarily present in the 
project, the path must be indicated as an argument of the build command.
**It is important not to rename the file names.**

At this point you can proceed with the build of the image using the command below.
In this case the downloaded bundles are inside the xxx directory and the resulting 
image will have the name `amusarra:liferay72-dxp-dev`. 
The image will not be published on the Docker repository (`no-push` param). 
The `jboss-eap` parameter indicates to create the Liferay Docker image with JBoss EAP.

```bash
./build_local_image.sh ../../bundles/ amusarra liferay72-dxp-dev no-push jboss-eap
```

The basic JBoss EAP configuration is governed by configuration files located 
within the following directory.

```bash
template
└── jboss-eap
   └── 7.2.0
       ├── bin
       │   └── standalone.conf
       ├── modules
       │   └── com
       │       └── liferay
       │           └── portal
       │               └── main
       │                   └── module.xml
       └── standalone
           └── configuration
               └── standalone.xml
```

It is possible to act on the basic configuration of JBoss EAP at the build level, 
thus modifying the configuration templates, or better still, by acting on the 
image configuration, as documented by Liferay itself.

Once the build process is finished, you should see the new image. 
The `docker images` command displays the newly created image.

```bash
REPOSITORY                 TAG                              IMAGE ID            CREATED             SIZE
amusarra                   liferay72-dxp-dev                dc47e5d30128        6 hours ago         1.89GB
amusarra                   liferay72-dxp-dev-202009291154   dc47e5d30128        6 hours ago         1.89GB
```

To launch the new image, just run the following command. As indicated in the 
Liferay documentation, in this command I have also indicated the volume, 
this allows you to deploy and act on the configuration of Liferay and JBoss.


```bash
docker run -d -it --name liferay72jboss -p 8080:8080 -p 11311:11311 -v $(pwd):/etc/liferay/mount -P amusarra:liferay72-dxp-dev
```