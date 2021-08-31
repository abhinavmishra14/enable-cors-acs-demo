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