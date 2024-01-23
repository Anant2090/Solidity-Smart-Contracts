// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract twitter_project
{
    struct tweet
    {
        uint id;
        address sender;
        string content;
        uint time;
    }

    struct Message
    {
        uint id;
        address sender;
        address receiver;
        string content;
        uint time;
    }

    mapping (uint=>tweet) public tweets; //this is used to create mapping of unique id tweet
    mapping (address=>uint[]) public tweets_of;// this is mapping of particular address to twit id which is send by particular address
    mapping (address=>Message[])public Messages_by_address;//this is mapping to messagges send by addess
    mapping (address=>tweet[]) public tweets_by_address;// this is mapping which has all twits send by the address
    mapping(address=>address[]) public following; // this is for followers and following
    mapping(address=>mapping(address=>bool)) public operator;//this is to give the access of msg.senders access to particular addrsss that that adderess can send message through message.senders address
    uint Tweetid;
    uint Messageid;


    function _twet(address from, string memory content) internal
    {
    
        tweets[Tweetid]=tweet(Tweetid,from,content,block.timestamp);
        Tweetid++;
    }

    function _send_message(address sender,address receiver,string memory content) internal
    {
        Messages_by_address[sender].push(Message(Messageid,sender,receiver,content,block.timestamp));
        Messageid++;
    }
    
    function tweet_by_msg_owner(string memory content) public 
    {
        
        _twet(msg.sender,content);

    }
    function tweet_by_owner_friend(address from,string memory content) public
    {
        require(operator[from][msg.sender]==true);
        _twet(from, content);
    }

    function msg_by_owner(address receiver,string memory content) public 
    {
        _send_message(msg.sender, receiver, content);
    }
    function msg_by_operator(address sender,address receiver,string memory content) public 
    {
        require(operator[sender][msg.sender]==true);
        _send_message(sender, receiver, content);
    }

    function follow(address _followed) public 
    {
        following[msg.sender].push(_followed);
    }

    function _give_permission_to_operator(address _operator) public
    {
        operator[msg.sender][_operator]=true;

    }
    function _deny_permisison_from_operator(address _operator) public
    {
        operator[msg.sender][_operator]=false;
    }

    function getlatesttweets(uint count) public view returns(tweet[] memory)
    {
        require(count>0 && count<Tweetid,"Count us not proper");
        tweet[] memory tweetss=new tweet[](count);
        uint j;
        for(uint i=Tweetid-count; i<Tweetid; i++)
        {
            tweetss[j]=tweets[i];
            j++;
        }
        return tweetss;


    }

    function user_latest_tweets(address user,uint count) public view returns(tweet[] memory)
    {
        require(count>0 && count<Tweetid,"Count us not proper");
        tweet[] memory user_tweet=new tweet[](count);
        uint j;
        for(uint i=Tweetid-count; i<Tweetid; i++)
        {
            user_tweet[j]=tweets_by_address[user][i];
            j++;
        }
        return user_tweet;


    }
}