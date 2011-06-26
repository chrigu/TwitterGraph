TwitterGraph
=========
TwitterGraph is a tiny <a href="http://processing.org">Processing</a> project that visualizes the 400ish last tweets from a timeline.
See an example on my <a href="http://www.trivialview.ch/blog/2011/06/my-twitter-timeline-is-so-sexy/?lang=en">blog</a>.

Warning
-------
Please not that the code is very ugly and that didn't invest too much time in doing everything very efficient. Moreover I'm not too fond of Java ;)

Setup
-----

**1. Obtain Processing**
<a href="http://processing.org">Processing</a>

**2. Put this projects code in your sketches directory**

**3. Get a Twitter API Key**
Get it from the <a href="https://dev.twitter.com/apps/new">developer site</a>

**4. Get an Oauth Token & Token Secret**
The token and the secret can be obtained by using the script from <a href="http://twitter4j.org">twitter4j</a>. Read twitter4j-<version>/bin/readme.txt
for more information.

Once you have all the required parameters change the following lines in the code.
<pre><code>
   cb.setDebugEnabled(true).setOAuthConsumerKey("Your Oauth Consumer Key");
   cb.setOAuthConsumerSecret("Your Oauth Consumer Secret");
   cb.setOAuthAccessToken("Your Oauth Access Token");
   cb.setOAuthAccessTokenSecret("Your Oauth Access Token Secret");
   cb.setUser("Your username");
   cb.setPassword("Your password");
</code></pre>