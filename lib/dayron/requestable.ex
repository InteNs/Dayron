defprotocol Dayron.Requestable do
  @doc """
  Given a json data for a single resource, returns a struct based on value/
  module parameter
  """
  def from_json(value, data, opts)

  @doc """
  Given a json data for multiple resources, returns a list of structs based on
  value/module parameter
  """
  def from_json_list(value, data, opts)

  @doc """
  Returns the url path representing the value/model and the options

  ## Example

      > Dayron.Requestable.url_for(MyModel, [id: id])
      "/mymodels/id"
  """
  def url_for(value, opts)
end

defimpl Dayron.Requestable, for: Atom do
  def from_json(module, data, opts) do
    try do
      module.__from_json__(data, opts)
    rescue
      UndefinedFunctionError -> raise_protocol_exception(module)
    end
  end

  def from_json_list(module, data, opts) do
    try do
      module.__from_json_list__(data, opts)
    rescue
      UndefinedFunctionError -> raise_protocol_exception(module)
    end
  end

  def url_for(module, opts) do
    try do
      module.__url_for__(opts)
    rescue
      UndefinedFunctionError -> raise_protocol_exception(module)
    end
  end

  defp raise_protocol_exception(module) do
    message = if :code.is_loaded(module) do
      "the given module is not a Dayron.Model"
    else
      "the given module does not exist"
    end

    raise Protocol.UndefinedError,
         protocol: @protocol,
            value: module,
      description: message
  end
end
