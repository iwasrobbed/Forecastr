Forecastr
=========

A simple Objective-C wrapper for Forecast.io

**Note:** You will need to [request an API key](https://developer.forecast.io) and set that key when you instantiate Forecastr, otherwise an exception will be thrown.

## Supports ##
* Specifying `US`, `SI`, or `UK` units
* Specifying a JSONP callback method name (e.g. `someJavascriptMethodName({jsonResponseGoesHere})`)
* Specifying exclusions in the response (e.g. leaving out `currently`, `minutely`, `hourly`, `daily`, `alerts`, or `flags`)

## Examples ##
* **Example App**: A simple example showing how to use all of the different options available through the API request
* **Detailed Example App**: An example app that uses CoreLocation to get the user's current location and then uses that to make a basic forecast request

License
=======

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.