import { LightningElement, track } from "lwc";

export default class ChatterFeedRCPVersion extends LightningElement {
  @track feedItems = [
    {
      Id: "FeedItem1",
      Body: "First post content here.",
      CreatedById: "UserId1",
      ParentId: "AccountId1",
      FeedComments: [
        {
          Id: "Comment1-1",
          CreatedById: "UserId2",
          CommentBody: "First comment on first post."
        },
        {
          Id: "Comment1-2",
          CreatedById: "UserId3",
          CommentBody: "Second comment on first post."
        }
      ],
      showComments: false
    },
    {
      Id: "FeedItem2",
      Body: "Second post content here.",
      CreatedById: "UserId4",
      ParentId: "AccountId2",
      FeedComments: [
        {
          Id: "Comment2-1",
          CreatedById: "UserId5",
          CommentBody: "First comment on second post."
        },
        {
          Id: "Comment2-2",
          CreatedById: "UserId6",
          CommentBody: "Second comment on second post."
        },
        {
          Id: "Comment2-3",
          CreatedById: "UserId7",
          CommentBody: "Third comment on second post."
        }
      ],
      showComments: false
    },
    {
      Id: "FeedItem3",
      Body: "Third post content here.",
      CreatedById: "UserId8",
      ParentId: "AccountId3",
      FeedComments: [],
      showComments: false
    },
    {
      Id: "FeedItem4",
      Body: "Fourth post content here.",
      CreatedById: "UserId9",
      ParentId: "AccountId4",
      FeedComments: [
        {
          Id: "Comment4-1",
          CreatedById: "UserId10",
          CommentBody: "Only comment on fourth post."
        }
      ],
      showComments: false
    }
    // ... Additional sample feed items ...
  ];

  toggleComments(event) {
    const feedItemId = event.target.dataset.id; // receive item.id which is feedItem id
    const feedItem = this.feedItems.find((item) => item.Id === feedItemId);
    if (feedItem) {
      feedItem.showComments = !feedItem.showComments;
      this.feedItems = [...this.feedItems];
    }
  }

  // ... Additional logic and handlers ...
}
