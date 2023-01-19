require "test_helper"

class FeaturedImagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @featured_image = featured_images(:one)
  end

  test "should get index" do
    get featured_images_url
    assert_response :success
  end

  test "should get new" do
    get new_featured_image_url
    assert_response :success
  end

  test "should create featured_image" do
    assert_difference("FeaturedImage.count") do
      post featured_images_url, params: { featured_image: {  } }
    end

    assert_redirected_to featured_image_url(FeaturedImage.last)
  end

  test "should show featured_image" do
    get featured_image_url(@featured_image)
    assert_response :success
  end

  test "should get edit" do
    get edit_featured_image_url(@featured_image)
    assert_response :success
  end

  test "should update featured_image" do
    patch featured_image_url(@featured_image), params: { featured_image: {  } }
    assert_redirected_to featured_image_url(@featured_image)
  end

  test "should destroy featured_image" do
    assert_difference("FeaturedImage.count", -1) do
      delete featured_image_url(@featured_image)
    end

    assert_redirected_to featured_images_url
  end
end
