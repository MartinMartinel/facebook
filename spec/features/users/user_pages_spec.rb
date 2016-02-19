describe 'User pages' do
  subject { page }
  let(:user) { create(:user, email: "central_user@example.com") }

  before(:each) do
    log_in(user.email, user.password)
  end

  describe "newsfeed" do

    describe "post creation" do
      before { visit newsfeed_path(user) }

      context "with no post content" do
        it "does not create a post" do
          expect { click_on "Post" }.not_to change{ Post.count }
        end
      end

      context "with post content" do
        before { fill_in "new_post", with: "Lorem ipsum post" }

        it "creates a post" do
          expect { click_on "Post" }.to change{ Post.count }.by(1)
        end
        it "displays the post" do
          click_on "Post"
          expect(page).to have_text("Lorem ipsum post")
        end
        it "displays the post's creator" do
          click_on "Post"
          within ".newsfeed-container" do
            expect(page).to have_text(user.name)
          end
        end
      end
    end

    describe "post deletion" do
      before do
        visit newsfeed_path(user)
        fill_in "new_post", with: "Lorem ipsum post"
        click_on "Post"
      end

      it "allows deletion of own post" do
        expect{ page.first(".delete").click }.to change{ Post.count }.by(-1)
      end
    end

    describe "comment creation" do
      before do
        visit newsfeed_path(user)
        fill_in "new_post", with: "Lorem ipsum"
        click_on "Post"
      end

      context "with no comment content" do
        it "does not create a comment" do
          expect { click_on "Comment" }.not_to change{ Comment.count }
        end
      end

      context "with comment content" do
        before do
          within('.post-container') do
            fill_in "Content", with: "Lorem ipsum comment"
          end
        end

        it "creates a comment" do
          expect { click_on "Comment" }.to change{ Comment.count }.by(1)
        end
        it "displays the comment" do
          click_on "Comment"
          expect(page).to have_text("Lorem ipsum comment")
        end
        it "displays the commenter's name" do
          click_on "Comment"
          within ".post-container" do
            expect(page).to have_text(user.name)
          end
        end
      end
    end

    describe "comment deletion" do
      before do
        visit newsfeed_path(user)
        fill_in "new_post", with: "Lorem ipsum post"
        click_on "Post"
        within('.post-container') do
          fill_in "Content", with: "Lorem ipsum comment"
          click_on "Comment"
        end
      end

      it "allows deletion of own comment" do
        expect{ page.find(".comment-container").find(".delete").click }.
          to change{ Comment.count }.by(-1)
      end
    end

    describe "liking a post" do
      before do
        visit newsfeed_path(user)
        fill_in "new_post", with: "Lorem ipsum"
        click_on "Post"
      end

      it "creates a like" do
        expect { click_on "Like" }.to change{ Like.count }.by(1)
      end
      it "enables unliking" do
        click_on "Like"
        expect(page).to have_link("Unlike")
      end
      it "can unlike" do
        click_on "Like"
        expect { click_on "Unlike" }.to change{ Like.count }.by(-1)
      end
    end

    describe "liking a comment" do
      before do
        visit newsfeed_path(user)
        fill_in "new_post", with: "Lorem ipsum"
        click_on "Post"
        visit newsfeed_path(user)
        within '.comment-form' do
          fill_in "Content", with: "Lorem"
          click_on "Comment"
        end
      end

      it "creates a like" do
        within '.comment-like' do
          expect { click_on "Like" }.to change{ Like.count }.by(1)
        end
      end
      it "enables unliking" do
        within '.comment-like' do
          click_on "Like"
        end
        expect(page).to have_link("Unlike")
      end
      it "can unlike" do
        within '.comment-like' do
          click_on "Like"
        end
        expect { click_on "Unlike" }.to change{ Like.count }.by(-1)
      end
    end
  end


  describe "index" do
    before(:each) do
      visit users_path
    end

    it { should have_text("All Users") }

    describe "friend management" do
      let(:other_user) { create(:user, first_name: "other", email: "other@example.com") }

      it "sends friend request" do
        create(:user)
        visit users_path
        click_on("Add Friend", match: :first)
        expect(page).to have_text("Friend Request Sent")
      end

      it "accepts friend request" do
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Accept"
        expect(page).to have_button("Unfriend")
      end

      it "rejects friend request" do
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Decline"
        expect(page).to have_submit("Add Friend")
      end

      it "unfriends" do
        other_user.send_friend_request_to(user)
        visit users_path
        click_on "Accept"
        click_on("Unfriend", match: :first)
        expect(page).to have_submit("Add Friend")
      end
    end

    describe "friendship status pages" do
      let(:friender1)  { create(:user, first_name: "friender1") }
      let(:friender2)  { create(:user, first_name: "friender2") }
      let(:friended1)  { create(:user, first_name: "friended1") }
      let(:friended2)  { create(:user, first_name: "friended2") }
      let(:friend1)    { create(:user, first_name: "friend1") }
      let(:friend2)    { create(:user, first_name: "friend2") }
      let(:no_friend1) { create(:user, first_name: "no_friend1") }
      let(:no_friend2) { create(:user, first_name: "no_friend2") }

      before(:each) do
        friender1  = create(:user, first_name: "friender1")
        friender2  = create(:user, first_name: "friender2")
        friended1  = create(:user, first_name: "friended1")
        friended2  = create(:user, first_name: "friended2")
        friend1    = create(:user, first_name: "friend1")
        friend2    = create(:user, first_name: "friend2")
        no_friend1 = create(:user, first_name: "no_friend1")
        no_friend1 = create(:user, first_name: "no_friend2")
        friender1.send_friend_request_to(user)
        friender2.send_friend_request_to(user)
        user.send_friend_request_to(friended1)
        user.send_friend_request_to(friended2)
        make_friends(user, friend1)
        make_friends(user, friend2)
      end

      describe "friends page" do
        before(:each) { visit friends_path(user) }

        it "has the correct header" do
          expect(page).to have_selector("h1", text: "Friends")
        end

        it "lists all friends" do
          expect(page).to have_link(friend1.name)
          expect(page).to have_link(friend2.name)
        end
      end

      describe "friend requests page" do
        before(:each) { visit friend_requests_path(user) }

        it "has the correct header" do
          expect(page).to have_selector("h1", text: "Friend Requests")
        end
        it "has the right number of friend requests" do
          expect(page).to have_submit("Accept", count: 2)
        end
        it "lists all friend requests" do
          expect(page).to have_link(friender1.name)
          expect(page).to have_link(friender2.name)
        end
      end

      describe "find friends page" do
        before(:each) { visit find_friends_path(user) }

        it "has the correct header" do
          expect(page).to have_selector("h1", text: "Find Friends")
        end
        it "has the right number of friends" do
          expect(page).to have_submit("Add Friend", count: 2)
        end
        it "lists all non-friends/requests" do
          expect(page).to have_link(friend1.name)
          expect(page).to have_link(friend2.name)
        end
      end
    end

    context "with multiple users" do
      let(:friender)  { create(:user, first_name: "friender") }
      let(:friended)  { create(:user, first_name: "friended") }
      let(:no_friend) { create(:user, first_name: "no_friend") }

      before(:each) do
        friender  = create(:user, first_name: "friender")
        friended  = create(:user, first_name: "friended")
        no_friend = create(:user, first_name: "no_friend")
        visit users_path
      end

      it "does not list current user" do
        expect(page).not_to have_text(user.full_name)
      end

      it "lists all other users" do
        expect(page).to have_text(friender.first_name)
        expect(page).to have_text(friended.first_name)
        expect(page).to have_text(no_friend.first_name)
      end
    end
  end

  describe "Timeline" do
    context "for current user" do
      before { visit timeline_path(user) }

      it { should have_css(".profile") }
      it { should have_xpath("//img[@class='v-lg-img']") }

      it "should have link to Timeline" do
        expect(find(".profile")).to have_link("Timeline")
      end
      it "should have link to About" do
        expect(find(".profile")).to have_link("About")
      end
      it "should have link to friends" do
        expect(find(".profile")).to have_link("Friends")
      end
      it "should have display for friend status" do
        expect(find(".profile")).to have_css(".friend-status")
      end

      context "as friend status" do
        let(:friender)  { create(:user, first_name: "friender") }
        let(:friended)  { create(:user, first_name: "friended") }
        let(:friend)    { create(:user, first_name: "friend") }
        let(:no_friend) { create(:user, first_name: "no_friend") }

        before(:each) do
          friender  = create(:user, first_name: "friender")
          friended  = create(:user, first_name: "friended")
          friend    = create(:user, first_name: "friend")
          no_friend = create(:user, first_name: "no_friend")
        end

        context "for the current user" do
          it "displays correct friend status" do
            visit timeline_path(user)
            expect(find(".friend-status")).
                to have_link("Update your Profile")
          end
        end
        context "for a friended" do
          it "displays correct friend status" do
            friend_request_from_to(user, friended)
            visit timeline_path(friended)
            expect(find(".friend-status")).
                to have_text("Friend request pending")
          end
        end
        context "for a friend" do
          it "displays correct friend status" do
            make_friends2(user, friend)
            visit timeline_path(friend)
# puts "USER: #{user.friends.count}"
# puts "FRIEND: #{friend.friends.count}"
# puts page.html
            expect(find(".friend-status")).
                to have_text("Friends with #{friend.first_name}")
          end
        end
        context "for a non-friend" do
          it "displays correct friend status" do
            visit timeline_path(no_friend)
            expect(find(".friend-status")).
                to have_text("Do you know #{no_friend.first_name}?")
            expect(find(".friend-status")).
                to have_submit("Add Friend")
          end
          it "allows friend request to be sent" do
            visit timeline_path(no_friend)
            friendships = Friendship.count
            within(".friend-status") do
              click_on("Add Friend")
            end
            expect(Friendship.count).to eq(friendships + 1)
          end
          it "displays correct status after sending friend request" do
            visit timeline_path(no_friend)
            within(".friend-status") do
              click_on("Add Friend")
            end
            expect(find(".friend-status")).
                to have_text("Friend request pending")
          end
        end
      end
    end
  end
end
