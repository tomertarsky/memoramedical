require 'net/http'
require 'json'
require 'uri'

class RetellAgentService
  RETELL_API_BASE_URL = 'https://api.retellai.com'
  DEFAULT_AGENT_ID = 'agent_58c4fba4908979f2eb68148515'

  def initialize(api_key = nil)
    @api_key = api_key || Rails.application.credentials.retell&.api_key
    raise ArgumentError, 'API key is required' if @api_key.nil? || @api_key.empty?
  end

  def update_agent(agent_id = nil, agent_params = {})
    agent_id = agent_id || DEFAULT_AGENT_ID
    raise ArgumentError, 'Agent ID is required' if agent_id.nil? || agent_id.empty?

    Rails.logger.info "Updating Retell agent: #{agent_id} with params: #{agent_params}"

    uri = URI("#{RETELL_API_BASE_URL}/update-agent/#{agent_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = agent_params.to_json

    begin
      response = http.request(request)

      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        raise StandardError, 'Unauthorized: Invalid API key'
      when 404
        raise StandardError, 'Agent not found'
      when 422 
        raise StandardError, "Validation error: #{JSON.parse(response.body)['message']}"
      else
        raise StandardError, "API request failed with status #{response.code}: #{response.body}"
      end
    rescue JSON::ParserError => e
      raise StandardError, "Failed to parse response: #{e.message}"
    rescue Timeout::Error, Net::OpenTimeout, Net::ReadTimeout => e
      raise StandardError, "Request timeout: #{e.message}"
    rescue StandardError => e
      raise e
    end
  end

  def get_agent(agent_id = nil)
    agent_id = agent_id || DEFAULT_AGENT_ID
    raise ArgumentError, 'Agent ID is required' if agent_id.nil? || agent_id.empty?

    uri = URI("#{RETELL_API_BASE_URL}/get-agent/#{agent_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"

    begin
      response = http.request(request)

      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        raise StandardError, 'Unauthorized: Invalid API key'
      when 404
        raise StandardError, 'Agent not found'
      else
        raise StandardError, "API request failed with status #{response.code}: #{response.body}"
      end
    rescue JSON::ParserError => e
      raise StandardError, "Failed to parse response: #{e.message}"
    rescue Timeout::Error, Net::OpenTimeout, Net::ReadTimeout => e
      raise StandardError, "Request timeout: #{e.message}"
    rescue StandardError => e
      raise e
    end
  end

  def list_agents
    uri = URI("#{RETELL_API_BASE_URL}/list-agents")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"

    begin
      response = http.request(request)

      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        raise StandardError, 'Unauthorized: Invalid API key'
      else
        raise StandardError, "API request failed with status #{response.code}: #{response.body}"
      end
    rescue JSON::ParserError => e
      raise StandardError, "Failed to parse response: #{e.message}"
    rescue Timeout::Error, Net::OpenTimeout, Net::ReadTimeout => e
      raise StandardError, "Request timeout: #{e.message}"
    rescue StandardError => e
      raise e
    end
  end

  def update_llm(llm_id, llm_params = {})
    raise ArgumentError, 'LLM ID is required' if llm_id.nil? || llm_id.empty?

    Rails.logger.info "Updating Retell LLM: #{llm_id} with params: #{llm_params}"

    uri = URI("#{RETELL_API_BASE_URL}/update-retell-llm/#{llm_id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Patch.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = llm_params.to_json

    begin
      response = http.request(request)

      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        raise StandardError, 'Unauthorized: Invalid API key'
      when 404
        raise StandardError, 'LLM not found'
      when 422
        raise StandardError, "Validation error: #{JSON.parse(response.body)['message']}"
      else
        raise StandardError, "API request failed with status #{response.code}: #{response.body}"
      end
    rescue JSON::ParserError => e
      raise StandardError, "Failed to parse response: #{e.message}"
    rescue Timeout::Error, Net::OpenTimeout, Net::ReadTimeout => e
      raise StandardError, "Request timeout: #{e.message}"
    rescue StandardError => e
      raise e
    end
  end

  private

  def handle_response(response)
    case response.code.to_i
    when 200..299
      JSON.parse(response.body)
    when 401
      raise StandardError, 'Unauthorized: Invalid API key'
    when 404
      raise StandardError, 'Resource not found'
    when 422
      error_message = JSON.parse(response.body)['message'] rescue 'Validation error'
      raise StandardError, "Validation error: #{error_message}"
    else
      raise StandardError, "API request failed with status #{response.code}: #{response.body}"
    end
  rescue JSON::ParserError => e
    raise StandardError, "Failed to parse response: #{e.message}"
  end
end
