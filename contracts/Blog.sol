// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;


contract Blog {
    constructor(){}

    // struct Comment {
    //     address commenter;
    //     string comment;
    // }

    struct Post {
        address creator;
        uint256 id; 
        string[] comments;
        uint256 thumbsUp;
        string postHead;
        string postBody;
    }

    Post[] internal  posts;
    uint256 public nextId = 1; 
    event PostCreated(uint256 indexed postId, string postHead, string message);

    modifier validAddress() {
        require(msg.sender != address(0), "Zero address not allowed");
        _;
    }

    function createBlog(string memory _postHead, string memory _postBody) validAddress public returns (bool) {
        Post memory mypost;
        mypost.creator = msg.sender;
        mypost.id = nextId;
        mypost.postHead = _postHead;
        mypost.postBody = _postBody;

        posts.push(mypost);
        emit PostCreated(nextId, _postHead, "Post created");

        nextId++; 
        return true;
    }

    function getBlog(uint256 _index) public view returns (string memory, string memory, string[] memory, address, uint256) {
        require(_index < posts.length, "Index is out of bound");

        Post memory mypost =posts[_index];

        return (mypost.postHead, mypost.postBody, mypost.comments, mypost.creator, mypost.thumbsUp);
    }

    function getAllBlogs() public view returns (Post[] memory) {
        return posts;
    }

    function commentOnBlog(string memory _comment, uint256 _postIndex)public validAddress returns (bool) {
        Post storage mypost = posts[_postIndex];
        mypost.comments.push(_comment);
        posts[_postIndex] = mypost;

        return true;
    }

    function upThumbs(uint256 _postIndex) public validAddress returns (bool) {
        Post storage mypost = posts[_postIndex];
        mypost.thumbsUp++;
        posts[_postIndex] = mypost;
        return true;
    }
}
