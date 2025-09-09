require "test_helper"

class AgentConfigsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @agent_config = agent_configs(:one)
  end

  test "should get index" do
    get agent_configs_url
    assert_response :success
  end

  test "should get new" do
    get new_agent_config_url
    assert_response :success
  end

  test "should create agent_config" do
    assert_difference("AgentConfig.count") do
      post agent_configs_url, params: { agent_config: { prompt: @agent_config.prompt, speech_speed: @agent_config.speech_speed } }
    end

    assert_redirected_to agent_config_url(AgentConfig.last)
  end

  test "should show agent_config" do
    get agent_config_url(@agent_config)
    assert_response :success
  end

  test "should get edit" do
    get edit_agent_config_url(@agent_config)
    assert_response :success
  end

  test "should update agent_config" do
    patch agent_config_url(@agent_config), params: { agent_config: { prompt: @agent_config.prompt, speech_speed: @agent_config.speech_speed } }
    assert_redirected_to agent_config_url(@agent_config)
  end

  test "should destroy agent_config" do
    assert_difference("AgentConfig.count", -1) do
      delete agent_config_url(@agent_config)
    end

    assert_redirected_to agent_configs_url
  end
end
