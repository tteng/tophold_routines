require 'test_helper'

class ProxySourcesControllerTest < ActionController::TestCase
  setup do
    @proxy_source = proxy_sources(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proxy_sources)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proxy_source" do
    assert_difference('ProxySource.count') do
      post :create, proxy_source: { url: @proxy_source.url }
    end

    assert_redirected_to proxy_source_path(assigns(:proxy_source))
  end

  test "should show proxy_source" do
    get :show, id: @proxy_source
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @proxy_source
    assert_response :success
  end

  test "should update proxy_source" do
    put :update, id: @proxy_source, proxy_source: { url: @proxy_source.url }
    assert_redirected_to proxy_source_path(assigns(:proxy_source))
  end

  test "should destroy proxy_source" do
    assert_difference('ProxySource.count', -1) do
      delete :destroy, id: @proxy_source
    end

    assert_redirected_to proxy_sources_path
  end
end
