
var GetURL = function() {};
GetURL.prototype = {
    run: function(arguments){
        arguments.completionFunction({"URL": document.URL, "TITLE": document.title, "PRICETEXT": document.getElementsByClassName("button success keydetails")[0].innerText});
    }
};
var ExtensionPreprocessingJS = new GetURL;
