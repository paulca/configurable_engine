require 'spec_helper'

describe Configurable do
  
  describe ".keys" do
    it "should collect the keys" do
      Configurable.keys.should == ['notify_email', 'log_out_sso']
    end
  end
  
  describe ".[]" do
    context "with no saved value" do
      it "shoud pick up the default value" do
        Configurable[:notify_email].should == 'mreider@engineyard.com'
      end
    end
    
    context "with a saved value" do
      before do
        Configurable.create!(:name => 'notify_email', :value => 'paul@rslw.com')
      end
      
      it "should find the new value" do
        Configurable[:notify_email].should == 'paul@rslw.com'
      end
    end
    
    context "with a boolean value" do
      before do
        Configurable.create!(:name => 'log_out_sso', :value => true)
      end
      
      it "should typecast the new value" do
        Configurable[:log_out_sso].should == true
        Configurable.log_out_sso?.should == true
      end
    end
  end
  
  describe ".method_missing" do
    it "should raise an error if a key doesn't exist" do
      lambda { Configurable.nonsense }.should raise_error(NoMethodError)
    end
    
    it "should return the correct value" do
      Configurable.notify_email.should == 'mreider@engineyard.com'
    end
  end
  
end
