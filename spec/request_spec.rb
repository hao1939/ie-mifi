require_relative 'test_helper.rb'

class RequestTest < MyAppTest
  def test_it_says_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello ieMiFi!', last_response.body
  end
end
