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
