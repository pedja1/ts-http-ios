ts-http
====================

Async http library for ios


Usage
=====


Including In Your Project
-------------------------

TODO adding library as project dependencie

Example
-------------------------

You use `TSRequestManager` for all requests  

#### Create new TSRequestManager

``` objective-c
TSRequestManager manager = [[TSRequestManager alloc] init];
```
or
``` objective-c
TSRequestManager manager = [[TSRequestManager alloc] init: true];
```
The second parameter indicates whether `TSRequestManager` will execute tasks on caller thread (thread that called `[manager executeRequestWithRequestCode]`) or on worker thread

#### Set a response handler dlegate

```objective-c
manager.responseHandlerDelegate = self;
```
#### Implement delegate method

```objective-c
- (void) onResponseWithRequestCode: (int) requestCode andResponseStatus: (int) responseStatus andResponseParser: (ResponseParser*) responseParser
{
    //you can handle response here, for example show it
    //you could also create your own implementation of ResponseParser that will parse the response and return the result
}
```  

#### Create a request

To create a request you will use `RequestBuilder`

```objective-c
RequestBuilder builder = [[RequestBuilder alloc] initWithMethod: POST];//create new RequestBuilder with HTTP POST method
builder.postMethod = X_WWW_FORM_URL_ENCODED;//set post method, X_WWW_FORM_URL_ENCODED is default so you don't need to set it
builder.requestUrl = @"http://tulfie.conveo.net/api/v1/";//set a request url. You can also call static method `setDefaultRequestUrl` once, instead of setting is every time
[builder addUrlPart: @"members"];//this will add param as part of the url. eg. http://tulfie.conveo.net/api/v1/member/login
[builder addUrlPart: @"login"];
[builder addParamWithKey: @"username" andValue: @"predragcokulov@gmail.com"];//add POST param, if HTTP method was GET, then this would put param in url. eg. http://tulfie.conveo.net/api/v1/member/login?username=predragcokulov@gmail.com
[builder addParamWithKey: @"password" andValue: @"123456";
```

#### Execute the request

```objective-c
[manager executeRequestWithRequestCode: REQUEST_CODE_LOGIN andRequestBuilder: builder);
```

If manager was created with `sync` param set to true, then this method will execute the request and return the response  
Otherwise it will return immediately (return value will be null), and you will get response in `ResponseHandler`  

By default request will be executed using default implementation `SimpleRequestHandlerDelegate`  
You can create your own and set it using  

```objective-c
[manager.requestHandlerDelegate = self;
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