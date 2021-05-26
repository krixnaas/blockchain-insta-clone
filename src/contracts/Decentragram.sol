pragma solidity ^0.5.0;

contract Decentragram {
    // Code goes here...
    string public name = "Decentragram";

    //Store Images
    uint256 public imageCount = 0;

    mapping(uint256 => Image) public images;

    struct Image {
        uint256 id;
        string hash;
        string description;
        uint256 tipAmount;
        address payable author;
    }

    event ImageCreated(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    event ImageTipped(
        uint256 id,
        string hash,
        string description,
        uint256 tipAmount,
        address payable author
    );

    // Create Images
    function uploadImage(string memory _imgHash, string memory _description)
        public
    {
        //Check image hash is exists
        require(bytes(_imgHash).length > 0);

        //Check image description is exists
        require(bytes(_description).length > 0);

        //Make sure uploader address exists
        require(msg.sender != address(0x0));

        //Increment Image ID
        imageCount++;

        //Add Image to Contract
        images[imageCount] = Image(
            imageCount,
            _imgHash,
            _description,
            0,
            msg.sender
        );

        //Trigger an event
        emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
    }

    // Tip Images
    function tipImageOwner(uint256 _id) public payable {
        //Make sure the id is valid
        require(_id > 0 && _id <= imageCount);
        //Fetch the image
        Image memory _image = images[_id];

        //Fetch the author
        address payable _author = _image.author;

        //Tip the author
        address(_author).transfer(msg.value);

        //Increment the tip amount
        _image.tipAmount = _image.tipAmount + msg.value;

        //Update the image
        images[_id] = _image;

        //Trigger an event
        emit ImageTipped(
            _id,
            _image.hash,
            _image.description,
            _image.tipAmount,
            _author
        );
    }
}
