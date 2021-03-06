defmodule Spec.Port do
  @doc """
  return execute result.
  """
  def exec do
    _pid = Port.open({:spawn, "ls README.md"}, [:binary, :stderr_to_stdout])
    port_data1 = receive do
      received_data ->
        {_, port_data} = received_data
        port_data
    end
    {port_data1}
  end
end
