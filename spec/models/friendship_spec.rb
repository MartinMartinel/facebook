require 'rails_helper'

describe Friendship do
  let(:friender) { create(:user) }
  let(:friended) { create(:user) }
  let(:friendship) { friender.friendships.build(friended_id: friended.id)}
  subject { friendship }

  it { should be_valid}
end
