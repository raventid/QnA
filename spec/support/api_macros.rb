module ApiMacros
  def json_request(method, path, options = {})
    send method, path, options.merge(format: :json)
  end
end