# frozen_string_literal: true

describe 'dummy app database configuration' do
  it 'ensures that the development and test databases are in different locations' do
    configs = ActiveRecord::Base.configurations
    dev_db = configs.find_db_config('development').database
    test_db = configs.find_db_config('test').database

    expect(dev_db).to match(/development/)
    expect(test_db).to match(/test/)
    expect(dev_db).not_to eq test_db
  end
end
