import twitter4j.Status;
import twitter4j.Twitter;
import twitter4j.TwitterException;
import twitter4j.TwitterFactory;
import twitter4j.User;
 
int w = 1500;
int h = 900;

int posY = h/2;

int noOfTweets = 0;

HashMap<String, Followee> users = new HashMap<String, Followee>();
 
void setup() {
  
          //setting up screen
        size(w, h);
        background(255,255,255);
  
  
        try {
            // gets Twitter instance with default credentials
            ConfigurationBuilder cb = new ConfigurationBuilder();
            
cb.setDebugEnabled(true).setOAuthConsumerKey("Your Oauth Consumer Key");
cb.setOAuthConsumerSecret("Your Oauth Consumer Secret");
cb.setOAuthAccessToken("Your Oauth Access Token");
cb.setOAuthAccessTokenSecret("Your Oauth Access Token Secret");
cb.setUser("Your username");
cb.setPassword("Your password");

TwitterFactory tf = new TwitterFactory(cb.build());
            Twitter twitter = tf.getInstance();
            User user = twitter.verifyCredentials();
            Paging page1 = new Paging(1, 200);
            Paging page2 = new Paging(2, 200);
            List<Status> statuses = twitter.getHomeTimeline(page1);
            List<Status> statuses2 = twitter.getHomeTimeline(page2);
            statuses.addAll(statuses2);
            ArrayList<Mention> retweets = new ArrayList();
            
            noOfTweets = statuses.size();
            int maxTweets = 0;
            
            for (Status status : statuses) {
              Boolean found = false;
              
               //System.out.println("user: " + aUser.name);
              Followee aUser = users.get(status.getUser().getScreenName()); 
              if(aUser != null) {
                aUser.noOfTweets++;
                String rtee = extractRt(status.getText());
                String replyTo = status.getInReplyToScreenName();
                if(rtee != null) {
                  aUser.tweets.add(new Mention(status.getUser().getScreenName(), rtee, 0, status.getText()));
                } else if(replyTo != null) {
                  aUser.tweets.add(new Mention(status.getUser().getScreenName(), replyTo, 1, status.getText()));
                } else {
                  aUser.tweets.add(new Tweet(status.getUser().getScreenName(), status.getText()));
                }
                  if(aUser.noOfTweets > maxTweets) {
                    maxTweets = aUser.noOfTweets;
                  }
                 found = true;
              }
              if(!found) {
                Followee followee = new Followee(status.getUser().getId(), status.getUser().getScreenName(), 1);
                String rtee = extractRt(status.getText());
                String replyTo = status.getInReplyToScreenName();
                if(rtee != null) {
                  followee.tweets.add(new Mention(status.getUser().getScreenName(), rtee, 0, status.getText()));
                } else if(replyTo != "") {
                  followee.tweets.add(new Mention(status.getUser().getScreenName(), replyTo, 1, status.getText()));
                } else {
                  followee.tweets.add(new Tweet(status.getUser().getScreenName(), status.getText()));
                }
                
                users.put(followee.name, followee);
                //System.out.println("@" + status.getUser().getScreenName() + " - " + status.getText() + " - " + status.getCreatedAt());
              }
            }
              /*
              System.out.println("---start---");
              
              System.out.println("In reply to " + status.getInReplyToScreenName());
              if(status.getInReplyToScreenName() != null){
                System.out.println(status.getText());
              }
              
              //check for RT
              String[] splitString0 = (status.getText().split("RT+\\s+@"));
              if(splitString0.length > 1) {
                //System.out.println(splitString0[1]);
                String[] splitString2 = (splitString0[1].split(":\\s+"));
                if(splitString2.length > 0) {
                  System.out.println("Retweet " + splitString2[0]);
                  Mention retweet = new Mention(status.getUser().getScreenName(), splitString2[0], 0, status.getText());
                  retweets.add(retweet);
                }
              }   
    
            System.out.println("---end---");          
            }
            */
            
            
            int delta = (w-10)/noOfTweets;
            int posx = 0;
            int userNo = 1;
            
            colorMode(HSB, users.size(), maxTweets, 100);
            
            
            //iterate through users and determine their x, and y positions + the colour
            for (String username : users.keySet()) {
                Followee aUser = users.get(username);
                //System.out.println("@" + aUser.name + ": " + (new Integer(aUser.noOfTweets)).toString() + " " + (new Integer(aUser.noOfTweets*delta)).toString());
                
                int user_width = aUser.noOfTweets*delta;
                aUser.user_width = user_width;
                
                aUser.x = posx + user_width/2;
                aUser.y = posY;
                
                aUser.colour = userNo;

                posx += user_width + 1;
                userNo++;
             }
             
             //iterate through all tweets, draw bezier first
             //inefficient to cicle 2x through all users & tweets, but well....
              for (String username : users.keySet()) {
               
                Followee aUser = users.get(username);
                //System.out.println("@" + aUser.name + ": " + (new Integer(aUser.noOfTweets)).toString() + " " + (new Integer(aUser.noOfTweets*delta)).toString());
                
                int i = 1;
                int replys = 0;
                
                for(Tweet tweet : aUser.tweets) {
                  if(tweet.getClass().getName() == "twittergraph$Mention") {
                    //it's a retweet
                    Mention mention = (Mention) tweet;
                    Followee retweetee = users.get(mention.to);
                    if(mention.type == 1) { 
                      if(retweetee != null) {
                        noFill();
                        stroke(100, 1, 90);
                        int multiplicator;
                        if(retweetee.x - aUser.x > w/3) {
                          multiplicator = 6;
                        } else {
                          multiplicator = 2;
                        }
                        int contr_y = posY - ((maxTweets*delta) + 30*(replys + 1));
                        int contr_y2 = posY + ((maxTweets*delta) + 30*(replys + 1));
                        replys++;
                        bezier(aUser.x, aUser.y, (retweetee.x - aUser.x)/4+aUser.x,contr_y,(retweetee.x - aUser.x)*3/4+aUser.x,contr_y,retweetee.x, retweetee.y);
                        bezier(aUser.x, aUser.y, (retweetee.x - aUser.x)/4+aUser.x,contr_y2,(retweetee.x - aUser.x)*3/4+aUser.x,contr_y2,retweetee.x, retweetee.y);
                      }
                    }       
                   
                  }
                  
                  i++;
            
                }
              }
             
             //draw arcs/circles for users
             for (String username : users.keySet()) {
               
               //calc max arc pos
               
                Followee aUser = users.get(username);
                //System.out.println("@" + aUser.name + ": " + (new Integer(aUser.noOfTweets)).toString() + " " + (new Integer(aUser.noOfTweets*delta)).toString());
                
                int i = 1;
                int replys = 0;
                
                for(Tweet tweet : aUser.tweets) {
                  
                  if(tweet.getClass().getName() == "twittergraph$Mention") {
                    //it's a retweet
                    Mention mention = (Mention) tweet;
                    Followee retweetee = users.get(mention.to);
                    if(mention.type == 0) { 
                      if(retweetee != null) {
                        fill(retweetee.colour, i, 100);
                      } else {
                        fill(aUser.colour, i,95);
                      }
                    } else {
                      continue;
                    }       
                   
                  } else {
                    fill(aUser.colour, i,100);
                  }
                  float f = (new Float(i-1)/aUser.noOfTweets);
                  float r = aUser.user_width*(1-f);
                  noStroke();
                  //arc(aUser.x, posY, r, r, PI,TWO_PI);
                  ellipse(aUser.x, posY, r, r);

                  
                  i++;
            
                }

             }
             
             PFont myFont;          
             myFont = createFont("FFScala", 32);
             textFont(myFont);
             text("count followees: " + users.size() + ", count tweets: " + noOfTweets, 50, h-50);
            
            
        } catch (TwitterException te) {
            te.printStackTrace();
            System.out.println("Failed to get timeline: " + te.getMessage());
            System.exit(-1);
        }
        
        System.out.println("count followees: " + users.size() + ", counts tweets: " + noOfTweets);
        
};

void draw() {
 
};


//wanted to do this static in the tweet class, but well, Java..... Dunno why it didn't work
//Extracts the user that's being retweeted
String extractRt(String aTweet){
  String[] splitString0 = (aTweet.split("RT+\\s+@"));
  if(splitString0.length > 1) {
    //System.out.println(splitString0[1]);
    String[] splitString2 = (splitString0[1].split(":\\s+"));
    if(splitString2.length > 0) {
      return splitString2[0];
     }
   } 
   return null;
}


// Classes


class Followee 
{
  int noOfTweets; 
  long id;
  String name;
  
  ArrayList<Tweet> tweets;
  
  int x;
  int y;
  int colour;
  int user_width;
  
   Followee(long theId, String theName, int noTweets) {
    id = theId;
    noOfTweets = noTweets;
    name = theName;
    tweets = new ArrayList();
  }

}

class Tweet 
{
  String user;
  String tweet;
   
  Tweet(String userName, String aTweet) {
    user = userName;
    tweet = aTweet;
  }
 
}

class Mention extends Tweet
{
  String to;
  int type;  //yeah, one could make subclasses, but well 0 = Retweet, 1 = Reply  
  
  Mention(String fromId, String toId, int theType, String aTweet) {
    super(fromId, aTweet);
    to = toId;
    type = theType;
  }
}

