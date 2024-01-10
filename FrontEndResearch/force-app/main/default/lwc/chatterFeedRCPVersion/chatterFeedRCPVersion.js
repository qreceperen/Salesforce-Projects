import { LightningElement, track } from "lwc";

export default class ChatterFeedRCPVersion extends LightningElement {
  @track items = []; // Decorated with @track for reactivity

  connectedCallback() {
    // Sample data from backend
    const backendData = [
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
        ]
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
        ]
      },
      {
        Id: "FeedItem3",
        Body: "Third post content here.",
        CreatedById: "UserId8",
        ParentId: "AccountId3",
        FeedComments: []
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
        ]
      }
      // ... Additional sample feed items ...
    ];

    // Transforming for lightning-tree
    this.items = backendData.map((post) => ({
      label: `${post.Body} - ${post.CreatedById}`, // Taking the Body of the post and using it as the label
      name: post.Id, // Using the Id of the post as the name
      expanded: false, // Setting expanded to true for all posts
      items: post.FeedComments.map((comment) => ({
        label: `${comment.CommentBody} - ${comment.CreatedById}`, // Combine CommentBody and CreatedById
        name: comment.Id,
        items: [] // Comments don't have nested items
      }))
    }));
  }
}
