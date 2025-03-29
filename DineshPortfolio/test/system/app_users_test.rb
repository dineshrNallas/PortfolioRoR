require "application_system_test_case"

class AppUsersTest < ApplicationSystemTestCase
  setup do
    @app_user = app_users(:one)
  end

  test "visiting the index" do
    visit app_users_url
    assert_selector "h1", text: "App users"
  end

  test "should create app user" do
    visit app_users_url
    click_on "New app user"

    fill_in "Email", with: @app_user.email
    fill_in "Name", with: @app_user.name
    fill_in "Password digest", with: @app_user.password_digest
    click_on "Create App user"

    assert_text "App user was successfully created"
    click_on "Back"
  end

  test "should update App user" do
    visit app_user_url(@app_user)
    click_on "Edit this app user", match: :first

    fill_in "Email", with: @app_user.email
    fill_in "Name", with: @app_user.name
    fill_in "Password digest", with: @app_user.password_digest
    click_on "Update App user"

    assert_text "App user was successfully updated"
    click_on "Back"
  end

  test "should destroy App user" do
    visit app_user_url(@app_user)
    click_on "Destroy this app user", match: :first

    assert_text "App user was successfully destroyed"
  end
end
