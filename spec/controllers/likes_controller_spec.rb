require 'rails_helper'

describe LikesController do
  let(:user)              { create(:user) }
  let(:likeable_post)     { create(:post) }

  before(:each) do
    sign_in user
    unless request.nil? or request.env.nil?
      request.env["HTTP_REFERER"] = "/" unless request.nil? or request.env.nil?
    end
  end

  describe "POST create of post like" do
    context "without Ajax" do
      it "creates a post like" do
        expect { post :create, likeable_id: likeable_post.id,
        likeable_type: "Post" }.to change{ Like.count }.by(1)
      end
    end
  end
end

