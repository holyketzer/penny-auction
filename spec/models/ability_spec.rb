require 'spec_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }
  let(:user) { nil }

  describe 'admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end

  describe 'manager' do
    let(:user) { create(:manager) }

    it_behaves_like 'manager'
  end

  describe 'user' do
    let(:user) { create(:user) }

    it_behaves_like 'guest'
    it_behaves_like 'user'
  end

  describe 'guest' do
    it_behaves_like 'guest'
    it { should_not be_able_to :create, Bid }
  end
end