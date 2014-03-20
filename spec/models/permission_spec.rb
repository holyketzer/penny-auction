require 'spec_helper'

describe Permission do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :subject }
    it { should validate_presence_of :action }
  end
end
