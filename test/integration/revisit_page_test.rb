require "test_helper"
GovukTest.configure

class RevisitPageTest < ActionDispatch::SystemTestCase
  setup do
    Capybara.current_driver = :headless_chrome
  end

  teardown do
    Capybara.use_default_driver
  end

  test "Returning to start of flow resets session" do
    visit "find-coronavirus-support/s"
    within "legend" do
      assert_page_has_content "What do you need help with because of coronavirus?"
    end
    check("None of these", visible: false)
    click_on "Continue"
    within "legend" do
      assert_page_has_content "Where do you want to find information about?"
    end
    visit "find-coronavirus-support/s"
    within "legend" do
      assert_page_has_content "What do you need help with because of coronavirus?"
    end
  end

  test "back link returns previously visited page with prefilled checkbox answer" do
    visit "find-coronavirus-support/s"
    within "legend" do
      assert_page_has_content "What do you need help with because of coronavirus?"
    end

    check("Getting food or medicine", visible: false)
    click_on "Continue"
    assert_page_has_content "Getting food"
    click_on "Back"
    assert_page_has_content "What do you need help with because of coronavirus?"

    checked_box = find(:css, "[value='getting_food']", visible: false)
    unchecked_box = find(:css, "[value='feeling_unsafe']", visible: false)

    assert_equal(checked_box.checked?, true)
    assert_equal(unchecked_box.checked?, false)
  end

  test "back link returns previously visited page with prefilled radio button answer" do
    visit "find-coronavirus-support/s"
    within "legend" do
      assert_page_has_content "What do you need help with because of coronavirus?"
    end

    check("Getting food or medicine", visible: false)
    click_on "Continue"
    assert_page_has_content "Getting food"
    choose("Yes", visible: false)
    click_on "Continue"
    assert_page_has_content "Getting food or medicine"
    click_on "Back"
    assert_page_has_content "Getting food"

    checked_button = find(:css, "[value='yes']", visible: false)
    unchecked_button = find(:css, "[value='no']", visible: false)

    assert_equal(checked_button.checked?, true)
    assert_equal(unchecked_button.checked?, false)
  end

  def assert_page_has_content(text)
    assert page.has_content?(text), "'#{text}' not found in page"
  end
end
