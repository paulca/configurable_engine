describe 'dummy app database configuration' do
  it 'ensures that the development and test databases are in different locations' do
    configs = ActiveRecord::Base.configurations
    dev_db = configs['development']['database']
    test_db = configs['test']['database']

    dev_db.should =~ /development/
    test_db.should =~ /test/
    dev_db.should_not == test_db
  end
end