# This is a multi-stage image building
# First stage to clean and compile the project with maven as a base
# Second stage to run our generated .jar file from target
# In the second stage we use "openjdk11" as base to run .jar
# We copy the jar from initial directory to new one "/opt/app"
# Then we run the command "java -jar"

# --> --> Docker official note about multi-stage build <-- <--
# With multi-stage builds, you use multiple FROM statements in your Dockerfile.
# Each FROM instruction can use a different base, and each of them begins a new stage of the build. 
# You can selectively copy artifacts from one stage to another, 
# leaving behind everything you don’t want in the final image. 
# To show how this works, let’s adapt the Dockerfile from the previous section to use multi-stage builds.


FROM maven:3.8-jdk-11 AS maven
# First we set up the working directory
WORKDIR /usr/src/app
# We copy all files from local machine to "app" folder in the container
COPY . /usr/src/app
# This bellow command is to normalize the project test (see doc)
RUN mvn spring-javaformat:apply  
# Compile and package the application to an executable JAR
RUN mvn package 



# For Java 11, 
FROM adoptopenjdk/openjdk11:alpine-jre
ARG JAR_FILE=spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar
# We change the working directory
WORKDIR /opt/app
# Copy the spring-boot-api-tutorial.jar from the maven stage to the /opt/app directory of the current stage.
COPY --from=maven /usr/src/app/target/${JAR_FILE} /opt/app/
# We run the app inside
ENTRYPOINT ["java","-jar","spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar"]
