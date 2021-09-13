ARG ACS_TAG

FROM alfresco/alfresco-content-repository-community:${ACS_TAG}

ARG TOMCAT_DIR=/usr/local/tomcat

#Change to root so that sed command can be executed
USER root

# Copy add-ons jar module if there are any
COPY Dockerfile add-ons/*.jar $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib/

# Copy any third party libraries if there are any
COPY Dockerfile libs/*.jar $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib/


# Copy and apply amp add-ons
COPY Dockerfile add-ons/*.amp $TOMCAT_DIR/amps/
RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
              $TOMCAT_DIR/amps $TOMCAT_DIR/webapps/alfresco -directory -nobackup -force
			  

# In base image it tries to write logs at root directory which requires 'root' user access while alfresco is running as 'alfresco' user hence can't write the logs and you would notice access denied error in console logs for this reason.
# To overcome this issue, we need to change the default log4j.properties located at: "/usr/local/tomcat/webapps/alfresco/WEB-INF/classes/log4j.properties"
RUN sed -i "s|log4j.appender.File.File\=alfresco.log|log4j.appender.File.File\=logs/alfresco.log |g" $TOMCAT_DIR/webapps/alfresco/WEB-INF/classes/log4j.properties ;
			 
# Create dirs for simple modules
RUN bash -c 'mkdir -pv $TOMCAT_DIR/modules/platform'

#Change back to alfresco
USER alfresco

#Setup simple module config
COPY simple-module-config/alfresco.xml $TOMCAT_DIR/conf/Catalina/localhost/
#Copy simple modules if you have any
COPY simple-modules/*.jar $TOMCAT_DIR/modules/platform/

#Copy updated web.xml
COPY web.xml $TOMCAT_DIR/webapps/alfresco/WEB-INF/web.xml


#Copy and override the alfresco-global.properties which comes with custom image. 
#It could be useful in cases when you already built a custom image but launch an container with some additional config in global properties.
COPY alfresco-global.properties $TOMCAT_DIR/shared/classes/alfresco-global.properties

#Copy custom log4j
COPY dev-log4j.properties $TOMCAT_DIR/shared/classes/alfresco/extension

#TODO:: Add more steps as needed


