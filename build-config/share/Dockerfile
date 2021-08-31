ARG SHARE_TAG

FROM alfresco/alfresco-share:${SHARE_TAG}

ARG TOMCAT_DIR=/usr/local/tomcat

# Copy add-ons jar module if there are any
COPY Dockerfile add-ons/*.jar $TOMCAT_DIR/webapps/share/WEB-INF/lib/

# Copy any third party libraries if there are any
COPY Dockerfile libs/*.jar $TOMCAT_DIR/webapps/share/WEB-INF/lib/

# Copy and apply amp add-ons
COPY Dockerfile add-ons/*.amp $TOMCAT_DIR/amps_share/
RUN java -jar $TOMCAT_DIR/alfresco-mmt/alfresco-mmt*.jar install \
              $TOMCAT_DIR/amps_share $TOMCAT_DIR/webapps/share -directory -nobackup -force
			  
# Create dirs for simple modules
RUN bash -c 'mkdir -pv $TOMCAT_DIR/modules/share'

#Setup simple module config
COPY simple-module-config/share.xml $TOMCAT_DIR/conf/Catalina/localhost/
#Copy simple modules if you have any
COPY simple-modules/*.jar $TOMCAT_DIR/modules/share/
			  
#TODO:: Add more steps as needed