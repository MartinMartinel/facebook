describe 'User pages' do
  subject { page }
  let(:user) { create(:user) }

  before(:each) do
    log_in(user.email, user.password)
  end

  describe 'newsfeed' do

    it { should have_text('Newsfeed') }
    it { should have_text(user.first_name) }

  end
end
