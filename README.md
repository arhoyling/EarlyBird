EarlyBird
=========

Early bird allows you to track Twitter public streams in real-time using hashtags.

Technical details
-----------------
### Twitter
#### Connection
The connection to twitter is done by AHTwitterConnector. This connector is responsible for opening a connection with Twitter stream api, using the account it is provided. 

As data received from Twitter is often fragmented, the connector manages the proper reconstruction of messages before forwarding them to its delegate. 
This is possible using the api's *delimited=length* paramater. When this parameter is set, every data chunk sent by twitter is preceeded by the size of the following message (in string format).
As the connection is maintained as long as the user whishes to receive new tweets, Twitter will regularly send data with a simple newline to maintain the connection.
The connector is also responsible for managing dynamic reconnection in case of TCP timeout (no data is received). The time interval between connection retries grows linearly (by 250ms, as per Twitter's documentation).

#### Tweets and Users
The twitter manager makes sure there is a valid twitter account configured on the device. It also handles error sent back from the connector.
The twitter manager is in charge of making proper tweet objects out of the messages forwarded by the connector. 
For this, it uses a special builder that parses Json data to create tweet objects. It is highly tolerant of the input and can easily be extended if we need new fields in the tweet object. The tweet builder uses a twitter user builder internally to populate a tweet's user information. The user builder can be used seamlessly to parse profile messages directly.

The manager forwards tweets to its delegate.

### User query
Query are done by the user via a simple textfield. It is not mandatory for the user to add a hash at the beginning of the keyword, but doing so is harmless. The main controller will add a hash if there is none or leave the keyword as it is.
The user cannot use whitespaces in queries. At the moment, the user can only query one hashtag at a time.

### Display
Incoming tweets are displayed in a stream widget (table) with the name of the author, the profile picture, the creation time, and the text.
The profile picture is fetched in the background when the tweet is added to the stream widget. The corresponding cell is either initialized with it (if the fetch was fast enough) or updated once the picture is retrieved.
Every new query will clear the stream widget of its current content.

### Main control
The main controller coordinates interaction between those components, transforming user queries in requests for the twitter manager and forwarding incoming tweets to the stream widget.

