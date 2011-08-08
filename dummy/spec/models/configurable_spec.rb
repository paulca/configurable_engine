require 'spec_helper'

describe Configurable do

  describe ".create" do
    it "should require a key" do
      Configurable.create(:name => nil).should have(1).error_on(:name)
    end

    it "should require a unique key" do
      Configurable.create!(:name => 'notify_email')
      Configurable.create(:name => 'notify_email').should have(1).error_on(:name)
    end
  end

  describe ".keys" do
    it "should collect the keys" do
      Configurable.keys.should == ['conversion_rate',
                                   'important_number',
                                   'log_out_sso',
                                   'long_list',
                                   'notify_email'
                                   ]
    end
  end

  describe ".[]=" do
    context "with no saved value" do
      it "creates a new entry" do
        Configurable[:notify_email] = "john@example.com"
        Configurable.find_by_name('notify_email').value.should == 'john@example.com'
        Configurable.count.should == 1
      end
    end

    context "with a saved value" do
      before do
        Configurable.create!(:name => 'notify_email', :value => 'paul@rslw.com')
      end

      it "updates the existing value" do
        Configurable[:notify_email] = "john@example.com"
        Configurable.find_by_name('notify_email').value.should == 'john@example.com'
        Configurable.count.should == 1
      end
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

    context "with a decimal value" do
      before do
        Configurable.create!(:name => 'conversion_rate', :value => 1.2)
      end

      it "should typecast the value" do
        Configurable.conversion_rate.should == BigDecimal.new('1.2')
      end
    end

    context "with an integer value" do
      before do
        Configurable.create!(:name => 'important_number', :value => 100)
      end

      it "should typecast the value" do
        Configurable.important_number.should == 100
      end
    end

    context "with a list value" do
      context "default" do
        it "should default to a list" do
          Configurable.long_list.should == [["One", 1], ["Two", 2], ["Three", 3]]
        end
      end

      context "with a value" do
        before do
          Configurable.create!({:name => "long_list",
                                :value => "Paul,7\nCiara,8\nBrian,9"})
        end

        it "should update the list" do
          Configurable.long_list.should == [["Paul", "7"],
                                            ["Ciara", "8"],
                                            ["Brian", "9"]]
        end
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

    it "should assign the correct value" do
      Configurable.notify_email = 'john@example.com'
      Configurable.notify_email.should == 'john@example.com'
    end
  end

end
