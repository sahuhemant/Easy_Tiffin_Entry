require "test_helper"

class TiffinsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tiffins_show_url
    assert_response :success
  end
end
