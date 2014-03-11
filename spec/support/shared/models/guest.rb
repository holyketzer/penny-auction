shared_examples_for 'guest' do
  it { should_not be_able_to :manage, :all }
  it { should_not be_able_to :read, :all }
  it { should_not be_able_to :manage, :admin }

  it { should be_able_to :read, Auction }
end