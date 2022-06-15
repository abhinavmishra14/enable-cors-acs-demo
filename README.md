# enable-cors-acs-demo
This project is a demo on how to setup CORS in dockerized environment. Using this project we are specifically trying to setup ```cors.allowOrigin``` to ```*``` as OUTOFTHEBOX settings for [ACS6.x](https://docs.alfresco.com/content-services/6.1/config/repository/#cross-origin-resource-sharing-cors-filters)
/[ACS7.x](https://docs.alfresco.com/content-services/latest/config/repository/#cors-configuration) doesn't work and seems broken at repo layer when ```*``` is set as value for ```cors.allowOrigin```.


### Steps at high level which will be implemented with help of docker-compose.yml and DockerFile

- Downloaded these jar files (exact specific versions as given below):
 
   - https://repo1.maven.org/maven2/com/thetransactioncompany/cors-filter/2.5/cors-filter-2.5.jar
   - https://repo1.maven.org/maven2/com/thetransactioncompany/java-property-utils/1.9.1/java-property-utils-1.9.1.jar
   
   
- Copied them to $TOMCAT_DIR/webapps/alfresco/WEB-INF/lib/ using DockerFile.


- Take the latest copy of web.xml from here: https://raw.githubusercontent.com/Alfresco/alfresco-community-repo/master/packaging/war/src/main/webapp/WEB-INF/web.xml


- Update the web.xml with CORS filters as suggested here: https://docs.alfresco.com/content-services/6.1/config/repository/#cross-origin-resource-sharing-cors-filters


- Set the value of ```cors.allowOrigin``` to ```*```

```xml
   <filter>
     <filter-name>CORS</filter-name>
     <filter-class>com.thetransactioncompany.cors.CORSFilter</filter-class>
     <init-param>
         <param-name>cors.allowGenericHttpRequests</param-name>
         <param-value>true</param-value>
     </init-param>
     <init-param>
         <param-name>cors.allowOrigin</param-name>
         <param-value>*</param-value>
     </init-param>
     <init-param>
         <param-name>cors.allowSubdomains</param-name>
         <param-value>true</param-value>
     </init-param>
     <init-param>
         <param-name>cors.supportedMethods</param-name>
         <param-value>GET, HEAD, POST, PUT, DELETE, OPTIONS</param-value>
     </init-param>
     <init-param>
         <param-name>cors.supportedHeaders</param-name>
         <param-value>origin, authorization, x-file-size, x-file-name, content-type, accept, x-file-type, range</param-value>
     </init-param>
     <init-param>
         <param-name>cors.exposedHeaders</param-name>
         <param-value>Accept-Ranges, Content-Encoding, Content-Length, Content-Range</param-value>
     </init-param>
     <init-param>
         <param-name>cors.supportsCredentials</param-name>
         <param-value>true</param-value>
     </init-param>
     <init-param>
          <param-name>cors.maxAge</param-name>
          <param-value>3600</param-value>
     </init-param>
   </filter>

  <filter-mapping>
     <filter-name>CORS</filter-name>
     <url-pattern>/api/*</url-pattern>
     <url-pattern>/service/*</url-pattern>
     <url-pattern>/s/*</url-pattern>
     <url-pattern>/cmisbrowser/*</url-pattern>
     <url-pattern>/definitions/*</url-pattern>
 </filter-mapping>

  ```


- Copy the web.xml to $TOMCAT_DIR/webapps/alfresco/WEB-INF/web.xml via DockerFile, alternatively you can also use "sed" tool to update the web.xml file within the image without downloading a local copy. 


#### Test CORS

- Create a file named 'index.html' with following content


```html
<!DOCTYPE html>
<html>

    <head>
        <meta charset="utf-8"/>
        <title>CORS Test</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script type='text/javascript' src="cors-test.js"></script>
    </head>
    <body onLoad='main();'>
    </body>
</html>
```


- Create a file named 'cors-test.js' with following content

```js
function main()
{
    console.log("main invoked...");
    console.log("ajax request to the api that require cors enabled");
    $.ajax
    ({
        dataType: "xml",
        url: "http://localhost:8080/alfresco/s/api/login?u=admin&pw=admin",
        success: function(data)
        {
            console.log("log response on success");
            console.log(data);
        }
    });
}
```

### To create the external volumes use following command:

`docker volume create <volumeName>`

### To purge the external volumes use following command:

`docker volume rm -f <volumeName>`

### To build use following command:

- To build the images, This command will ignore any images which are already built and no changes to DockerFile has been identified. It will use cache.

`docker-compose -f ./docker-compose.yml build`

- To build the images with no cache. It will force rebuild

`docker-compose -f ./docker-compose.yml build --no-cache`


### To launch containers use following command:

`docker-compose -f ./docker-compose.yml up`


### To build and launch containers use following command:

`docker-compose -f ./docker-compose.yml up --build`


### To shutdown use following command:

`docker-compose -f ./docker-compose.yml down`

### To tail logs use following command:

`docker-compose -f ./docker-compose.yml logs -f`


### You can use launcher.bat/launcher.sh script to build, start, stop, purge volumes and tail logs:

- For Windows:

`.\launcher.bat build`

`.\launcher.bat start`

`.\launcher.bat stop`

`.\launcher.bat purge`

`.\launcher.bat tail`


- For Linux:

`.\launcher.sh build`

`.\launcher.sh start`

`.\launcher.sh stop`

`.\launcher.sh purge`

`.\launcher.sh tail`
