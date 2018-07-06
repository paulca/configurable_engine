describe 'dummy app database configuration' do
  it 'ensures that the development and test databases are in different locations' do
    configs = ActiveRecord::Base.configurations
    dev_db = configs['development']['database']
    test_db = configs['test']['database']

    expect(dev_db).to match(/development/)
    expect(test_db).to match(/test/)
    expect(dev_db).to_not eq test_db
  end
end
