import { LightningElement, track } from "lwc";

export default class ChatterFeed extends LightningElement {
  @track feedItems = [
    // Sample feed items with varying numbers of comments
    {
      Id: "FeedItem1",
      Body: "First post content here.",
      FeedComments: [
        { Id: "Comment1-1", CommentBody: "First comment on first post." },
        { Id: "Comment1-2", CommentBody: "Second comment on first post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem2",
      Body: "Second post content here.",
      FeedComments: [
        { Id: "Comment2-1", CommentBody: "First comment on second post." },
        { Id: "Comment2-2", CommentBody: "Second comment on second post." },
        { Id: "Comment2-3", CommentBody: "Third comment on second post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem3",
      Body: "Third post content here.",
      FeedComments: [],
      showComments: false
    },
    {
      Id: "FeedItem4",
      Body: "Fourth post content here.",
      FeedComments: [
        { Id: "Comment4-1", CommentBody: "Only comment on fourth post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem5",
      Body: "Fifth post content here.",
      FeedComments: [
        { Id: "Comment5-1", CommentBody: "First comment on fifth post." },
        { Id: "Comment5-2", CommentBody: "Second comment on fifth post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem6",
      Body: "Sixth post content here.",
      FeedComments: [],
      showComments: false
    },
    {
      Id: "FeedItem7",
      Body: "Seventh post content here.",
      FeedComments: [
        { Id: "Comment7-1", CommentBody: "First comment on seventh post." },
        { Id: "Comment7-2", CommentBody: "Second comment on seventh post." },
        { Id: "Comment7-3", CommentBody: "Third comment on seventh post." },
        { Id: "Comment7-4", CommentBody: "Fourth comment on seventh post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem8",
      Body: "Eighth post content here.",
      FeedComments: [
        { Id: "Comment8-1", CommentBody: "Sole comment on eighth post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem9",
      Body: "Ninth post content here.",
      FeedComments: [
        { Id: "Comment9-1", CommentBody: "Lone comment on ninth post." }
      ],
      showComments: false
    },
    {
      Id: "FeedItem10",
      Body: "Tenth post content here.",
      FeedComments: [
        { Id: "Comment10-1", CommentBody: "First comment on tenth post." },
        { Id: "Comment10-2", CommentBody: "Second comment on tenth post." },
        { Id: "Comment10-3", CommentBody: "Third comment on tenth post." }
      ],
      showComments: false
    }
  ];

  toggleComments(event) {
    const feedItemId = event.target.dataset.id;
    const feedItem = this.feedItems.find((item) => item.Id === feedItemId);
    if (feedItem) {
      feedItem.showComments = !feedItem.showComments;
      this.feedItems = [...this.feedItems]; // Trigger UI update
    }
  }

  // ... Additional logic and handlers ...
}
