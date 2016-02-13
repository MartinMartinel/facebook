describe 'User pages' do
  subject { page }
  let(:user) { create(:user, email: "central_user@example.com") }

  before(:each) do
    log_in(user.email, user.password)
  end

  describe 'newsfeed' do

    it { should have_text('Newsfeed') }
    it { should have_text(user.first_name) }

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
        expect(page).not_to have_text(user.first_name)
      end

      it "lists all other users" do
        expect(page).to have_text(friender.first_name)
        expect(page).to have_text(friended.first_name)
        expect(page).to have_text(no_friend.first_name)
      end
    end
  end
end
