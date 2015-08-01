defmodule Ablation.ClientGroup do
  require Logger

  @group_name :group

  def start() do
    {:ok, _pg2_pid} = :pg2.start()
    :pg2.create(@group_name)
  end

  def join(pid) do
    :pg2.join @group_name, pid
  end

  def members() do
    :pg2.get_members(@group_name)
  end

  def send_msg(current_pid, msg) do
    for pid <- members, pid != current_pid do
      GenServer.cast pid, {:send_message, msg}
    end
  end

end
