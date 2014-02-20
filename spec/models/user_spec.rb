require 'spec_helper'

describe User do
  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }    
  end

  describe 'associations' do
    it { should have_many(:bids) }
    it { should have_many(:authorizations) }
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already registered' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
 
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end
 
        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end
 
        it 'creates authorization with provider and uid' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
 
        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user not registered' do
        let(:new_user) { build(:user) }
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: new_user.email }) }
 
        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end
 
        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq new_user.email
        end
 
        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
 
          expect(user.authorizations).to_not be_empty
        end
 
        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
 
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
