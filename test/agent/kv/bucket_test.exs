defmodule Agent.KV.BucketTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, kv} = Agent.KV.start_link
    {:ok, kv: kv}
  end

  test "Check KV bucket work with no pid", %{kv: kv} do
    {:ok, bucket_pid} = Agent.KV.create :bucket1
    Agent.KV.put :bucket1, :key, {:ok, kv}

    assert {:ok, bucket_pid} == Agent.KV.lookup :bucket1
    assert {:ok, kv} == Agent.KV.get :bucket1, :key
    assert {:ok, kv} == Agent.KV.delete :bucket1, :key
    assert nil == Agent.KV.get :bucket1, :key
    
    Agent.KV.stop
  end

  test "Check KV bucket work with pid", %{kv: kv} do
    {:ok, bucket_pid} = Agent.KV.create kv, :bucket1
    Agent.KV.put kv, :bucket1, :key, {:ok, kv}

    assert {:ok, bucket_pid} == Agent.KV.lookup kv, :bucket1
    assert {:ok, kv} == Agent.KV.get kv, :bucket1, :key
    assert {:ok, kv} == Agent.KV.delete kv, :bucket1, :key
    assert nil == Agent.KV.get kv, :bucket1, :key

    Agent.KV.stop
  end

  test "Check KV 2 bucket work", %{kv: kv} do
    {:ok, bucket1_pid} = Agent.KV.create :bucket1
    {:ok, bucket2_pid} = Agent.KV.create :bucket2

    Agent.KV.put :bucket1, :key, {:ok, kv, bucket1_pid}
    Agent.KV.put :bucket2, :key, {:ok, kv, bucket2_pid}

    Agent.KV.put :bucket1, :key2, {:ok, :key2, bucket1_pid}
    Agent.KV.put :bucket2, :key2, {:ok, :key2, bucket2_pid}

    assert {:ok, bucket1_pid} == Agent.KV.lookup kv, :bucket1
    assert {:ok, kv, bucket1_pid} == Agent.KV.get :bucket1, :key
    assert {:ok, kv, bucket1_pid} == Agent.KV.delete :bucket1, :key
    assert nil == Agent.KV.get :bucket1, :key

    assert {:ok, bucket2_pid} == Agent.KV.lookup kv, :bucket2
    assert {:ok, kv, bucket2_pid} == Agent.KV.get :bucket2, :key
    assert {:ok, kv, bucket2_pid} == Agent.KV.delete :bucket2, :key
    assert nil == Agent.KV.get :bucket2, :key

    assert {:ok, :key2, bucket1_pid} == Agent.KV.get :bucket1, :key2
    assert {:ok, :key2, bucket2_pid} == Agent.KV.get :bucket2, :key2

    assert Process.alive?(kv) == true
    Agent.KV.stop
    assert Process.alive?(kv) == false
  end
end
