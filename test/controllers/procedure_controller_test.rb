require 'test_helper'

class ProcedureControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get procedure_index_url
    assert_response :success
  end

  test "should get create" do
    get procedure_create_url
    assert_response :success
  end

end
