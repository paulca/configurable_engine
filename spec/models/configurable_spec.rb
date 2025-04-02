# frozen_string_literal: true

require 'spec_helper'

describe Configurable do
  describe '.create' do
    it 'requires a key' do
      expect(Configurable.create(name: nil)).to have(1).error_on(:name)
    end

    it 'requires a unique key' do
      Configurable.create!(name: 'notify_email')
      expect(Configurable.create(name: 'notify_email')).to have(1).error_on(:name)
    end
  end

  describe '.keys' do
    it 'collects the keys' do
      expect(Configurable.keys).to eq %w[accept_applications
                                         conversion_rate
                                         important_date
                                         important_number
                                         log_out_sso
                                         long_list
                                         notify_email]
    end
  end

  describe '.[]=' do
    context 'with no saved value' do
      it 'creates a new entry' do
        expect do
          Configurable[:notify_email] = 'john@example.com'
        end.to change(Configurable, :count).from(0).to(1)
        expect(Configurable.find_by_name('notify_email').value).to eq 'john@example.com'
      end
    end

    context 'with a saved value' do
      before do
        Configurable.create! do |c|
          c.name = 'notify_email'
          c.value = 'paul@rslw.com'
        end
      end

      it 'updates the existing value' do
        expect do
          Configurable[:notify_email] = 'john@example.com'
        end.not_to change Configurable, :count
        expect(Configurable.find_by_name('notify_email').value).to eq 'john@example.com'
      end
    end

    context 'with a list value' do
      it 'updates the existing value' do
        new_list = [%w[Four 4], %w[Five 5], %w[Six 6]]
        Configurable[:long_list] = new_list
        expect(Configurable.long_list).to eq new_list
      end
    end

    context 'with a date value' do
      it 'updates the existing value' do
        new_date = Date.today
        Configurable[:important_date] = new_date
        expect(Configurable.important_date).to eq new_date
      end
    end
  end

  describe '.[]' do
    context 'with no saved value' do
      it 'shoud pick up the default value' do
        expect(Configurable[:notify_email]).to eq 'mreider@engineyard.com'
      end
    end

    context 'with a saved value' do
      before do
        Configurable.create!(name: 'notify_email', value: 'paul@rslw.com')
      end

      it 'finds the new value' do
        expect(Configurable[:notify_email]).to eq 'paul@rslw.com'
      end
    end

    context 'with a boolean value' do
      before do
        Configurable.create!(name: 'log_out_sso', value: true)
      end

      it 'typecasts the new value' do
        expect(Configurable[:log_out_sso]).to be true
        expect(Configurable.log_out_sso?).to be true
      end
    end

    context 'with a default boolean of true and a configuration set to false' do
      before do
        Configurable.create!(name: 'accept_applications', value: false)
      end

      it 'typecasts the new value' do
        expect(Configurable[:accept_applications]).to be false
        expect(Configurable.accept_applications).to be false
      end
    end

    context 'with a decimal value' do
      before do
        Configurable.create!(name: 'conversion_rate', value: 1.2)
      end

      it 'typecasts the value' do
        expect(Configurable.conversion_rate).to eq BigDecimal('1.2')
      end
    end

    context 'with an integer value' do
      before do
        Configurable.create!(name: 'important_number', value: 100)
      end

      it 'typecasts the value' do
        expect(Configurable.important_number).to eq 100
      end
    end

    context 'with a date value' do
      before do
        Configurable.create!(name: 'important_date', value: '2016-11-23')
      end

      it 'typecasts the value' do
        expect(Configurable.important_date).to eq Date.parse('2016-11-23')
      end
    end

    context 'with a list value' do
      context 'default' do
        it 'defaults to a list' do
          expect(Configurable.long_list).to eq [['One', 1], ['Two', 2], ['Three', 3]]
        end
      end

      context 'with a value' do
        before do
          Configurable.create!({ name: 'long_list',
                                 value: "Paul,7\nCiara,8\nBrian,9" })
        end

        it 'updates the list' do
          expect(Configurable.long_list).to eq [%w[Paul 7],
                                                %w[Ciara 8],
                                                %w[Brian 9]]
        end
      end
    end
  end

  describe '.method_missing' do
    it "raises an error if a key doesn't exist" do
      expect { Configurable.nonsense }.to raise_error(NoMethodError)
    end

    it 'returns the correct value' do
      expect(Configurable.notify_email).to eq 'mreider@engineyard.com'
    end

    it 'assigns the correct value' do
      Configurable.notify_email = 'john@example.com'
      expect(Configurable.notify_email).to eq 'john@example.com'
    end
  end
end
