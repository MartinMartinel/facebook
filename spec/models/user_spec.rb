describe User do
  let(:user) {create(:user)}
  subject { user }

  it { should be_valid }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:friendships) }
  it { should respond_to(:reverse_friendships) }
  it { should respond_to(:frienders) }
  it { should respond_to(:friended_users) }

  describe "validations" do
    it { should allow_value("foo@example.com").for(:email) }
    it { should_not allow_value("foo@example").for(:email) }
    it { should_not allow_value("@example.com").for(:email) }
  end

  describe "associations" do
    it { should have_many(:friendships).dependent(:destroy)}
    it { should have_many(:friended_users) }
    it { should have_many(:frienders)}
    it { should have_many(:reverse_friendships).dependent(:destroy) }
  end

  describe "friending" do
    let(:friended) { create(:user) }
    describe "#send_friend_request_to" do

      it "creates a new friend request" do
        user.send_friend_request_to(friended)
        expect(user.has_friend_request_from?(friended)).to be_falsey
        expect(friended.has_friend_request_from?(user)).to be_truthy
      end

      it "doesn't duplicate friend requests" do
        expect{user.send_friend_request_to(friended)}.to change{Friendship.count}.by(1)
        expect{friended.send_friend_request_to(user)}.not_to change{Friendship.count}
      end

      it "doesn't send friend request to friends" do
        make_friends(user, friended)
        expect{friended.send_friend_request_to(user)}.not_to change{Friendship.count}
      end
    end

    describe "#accept_friend_request_from" do
      it "accepts friend request" do
        make_friends(user, friended)
        expect(user.friends_with?(friended)).to be_truthy
        expect(friended.friends_with?(user)).to be_truthy
      end
    end

    describe "#reject_friend_request_from" do
      it "rejects friend request" do
        user.send_friend_request_to friended
        friended.reject_friend_request_from user
        expect(friended.has_friend_request_from?(user)).to be_falsey
      end
    end

    describe "#unfriend" do

      before { make_friends(user,friended) }

      it "allows friender to unfriend friended" do
        user.unfriend(friended)
        expect(user.friends_with?(friended)).to be_falsey
        expect(friended.friends_with?(user)).to be_falsey
      end

      it "allows friended to unfriend friender" do
        friended.unfriend(user)
        expect(friended.friends_with?(user)).to be_falsey
        expect(user.friends_with?(friended)).to be_falsey
      end
    end

    describe "#friends" do
      it "gets all friends of a given user" do
        make_friends(user, friended)
        expect(user.friends).to include(friended)
        expect(friended.friends).to include(user)
      end
    end
  end

end
