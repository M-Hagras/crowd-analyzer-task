# README

* Use RVM to install ruby 2.7.1
* Run bundle install
* Add .env file
* Add `SQS_URL`, `SQQ_ACCESS_KEY`, `SQQ_SECRET` to .env file
* Run rails s
* Each minute Generator service that mock data and Consumer service that consume data are fired


`Suggestions for authorizing organization:
`    *api call: this gives us on time data, no extra data on our app, but adds time latency, dependent on this api change, how to handle failure 
    *migrate view of organization ids and its enable status: in app data, no time latency, but dependent on other service schema
    *having table of organization data and its enable status (update by listen to queue): require the other system to send data through queue, no dependency
