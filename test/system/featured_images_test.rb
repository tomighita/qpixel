require "application_system_test_case"

class FeaturedImagesTest < ApplicationSystemTestCase
  setup do
    @featured_image = featured_images(:one)
  end

  test "visiting the index" do
    visit featured_images_url
    assert_selector "h1", text: "Featured images"
  end

  test "should create featured image" do
    visit featured_images_url
    click_on "New featured image"

    click_on "Create Featured image"

    assert_text "Featured image was successfully created"
    click_on "Back"
  end

  test "should update Featured image" do
    visit featured_image_url(@featured_image)
    click_on "Edit this featured image", match: :first

    click_on "Update Featured image"

    assert_text "Featured image was successfully updated"
    click_on "Back"
  end

  test "should destroy Featured image" do
    visit featured_image_url(@featured_image)
    click_on "Destroy this featured image", match: :first

    assert_text "Featured image was successfully destroyed"
  end
end
