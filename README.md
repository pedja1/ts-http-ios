ts-http
====================

Async http library


Usage
=====


Including In Your Project
-------------------------

Add maven url in repositories:
```groovy
maven { url 'http://maven.android-forever.com/' }
```
Add the library to your dependencies:
```groovy
compile 'com.tehnicomsolutions:ts-http:1.1.3.1'
```

Example
-------------------------

You use `TSRequestManager` for all requests  

#### First instantiate TSHttp. 
You should probably put this in your `Application` class or your main `Activity` class  
You only need to do it once. This CANNOT be null. This method will call `getApplicationContext` on passed context.

``` java
TSHttp.init(Context);
```

#### Create new TSRequestManager

``` java
TSRequestManager manager = new TSRequestManager(this, false);
```  
The second parameter indicates whether `TSRequestManager` will execute tasks on caller thread (thread that called `manager.execute`) or on worker thread

#### Add a response handler callback

```java
manager.addResponseHandler(new ResponseHandler()
{
    @Override
    public void onResponse(int requestCode, int responseStatus, ResponseParser responseParser)
    {
        //you can handle response here, for example show it
        tvResponse.setText(responseParser.getServerResponse().responseData);
        //you could also create your own implementation of ResponseParser that will parse the response and return the result
    }
});
```

#### Create a request

To create a request you will use `RequestBuilder`

```java
RequestBuilder builder = new RequestBuilder(RequestBuilder.Method.POST);//create new RequestBuilder with HTTP POST method
builder.setPostMethod(RequestBuilder.PostMethod.X_WWW_FORM_URL_ENCODED);//set post method, X_WWW_FORM_URL_ENCODED is default so you don't need to set it
builder.setRequestUrl("http://tulfie.conveo.net/api/v1/");//set a request url. You can also call static method `setDefaultRequestUrl` once, instead of setting is every time
builder.addParam("members");//this will add param as part of the url. eg. http://tulfie.conveo.net/api/v1/member/login
builder.addParam("login");
builder.addParam("username", "predragcokulov@gmail.com");//add POST param, if HTTP method was get, then this would put param in url. eg. http://tulfie.conveo.net/api/v1/member/login?username=predragcokulov@gmail.com
builder.addParam("password", "123456");
builder.addParam("grant_type", "password");
builder.addParam("client_id", "fnbAvzRXEpcCVhzDBWMa5WxYqksXwvfL");
builder.addParam("client_secret", "MVmUrQNx8ZLechxb");
```

#### Execute the request

```java
manager.execute(REQUEST_CODE_LOGIN, builder);
```

If manager was created with `sync` param set to true, then this method will execute the request and return the response  
Otherwise it will return immediately (return value will be null), and you will get response in `ResponseHandler`  

By default request will be executed using default implementation `SimpleRequestHandler`  
You can create your own and set it using  

```java
manager.setRequestHandler(RequestHandler);
```

Developed By
============

* Predrag Čokulov - <predragcokulov@gmail.com>



License
=======

    Copyright 2014 Predrag Čokulov

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.



 [1]: https://github.com/pedja1/FontWidgets/releases