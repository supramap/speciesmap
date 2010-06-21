require 'test_helper'

class PointmapsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pointmaps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pointmap" do
    assert_difference('Pointmap.count') do
      post :create, :pointmap => { }
    end

    assert_redirected_to pointmap_path(assigns(:pointmap))
  end

  test "should show pointmap" do
    get :show, :id => pointmaps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pointmaps(:one).to_param
    assert_response :success
  end

  test "should update pointmap" do
    put :update, :id => pointmaps(:one).to_param, :pointmap => { }
    assert_redirected_to pointmap_path(assigns(:pointmap))
  end

  test "should destroy pointmap" do
    assert_difference('Pointmap.count', -1) do
      delete :destroy, :id => pointmaps(:one).to_param
    end

    assert_redirected_to pointmaps_path
  end
end
