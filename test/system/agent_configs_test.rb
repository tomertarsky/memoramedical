require "application_system_test_case"

class AgentConfigsTest < ApplicationSystemTestCase
  setup do
    @agent_config = agent_configs(:one)
  end

  test "visiting the index" do
    visit agent_configs_url
    assert_selector "h1", text: "Agent configs"
  end

  test "should create agent config" do
    visit agent_configs_url
    click_on "New agent config"

    fill_in "Prompt", with: @agent_config.prompt
    fill_in "Speech speed", with: @agent_config.speech_speed
    click_on "Create Agent config"

    assert_text "Agent config was successfully created"
    click_on "Back"
  end

  test "should update Agent config" do
    visit agent_config_url(@agent_config)
    click_on "Edit this agent config", match: :first

    fill_in "Prompt", with: @agent_config.prompt
    fill_in "Speech speed", with: @agent_config.speech_speed
    click_on "Update Agent config"

    assert_text "Agent config was successfully updated"
    click_on "Back"
  end

  test "should destroy Agent config" do
    visit agent_config_url(@agent_config)
    accept_confirm { click_on "Destroy this agent config", match: :first }

    assert_text "Agent config was successfully destroyed"
  end
end
