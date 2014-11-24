defmodule SpecTest do
  use ExUnit.Case

  defmodule SpecNumber do
    use ExUnit.Case

    test "(decimal)1_000_000 is a number" do
      assert 1_000_000 === 1000000
    end
    test "(hexadecimal)0x1f is a number" do
      assert 0x1f === 31
    end
    test "(octal)0o765 is a number" do
      assert 0o765 === 501
    end
    test "(binary)0b1010 is a number" do
      assert 0b1010 === 10
    end
    test "(floating)0.314e1 is a number" do
      assert 0.314e1 === 3.14
    end
    test "(floating)314.0e-2 is a number" do
      assert 314.0e-2 === 3.14
    end
  end

  defmodule SpecRange do
    use ExUnit.Case

    test "1..10 and Enum.map +1" do
      range = 1..10
      assert [3, 4, 5, 6, 7, 8, 9, 10, 11, 12] === Enum.map range, &(&1 + 2)
    end
  end

  defmodule SpecRegEx do
    use ExUnit.Case

    test "Regex digit" do
      reg = ~r{(\d*)}i
      assert ["123", "123"] === Regex.run reg, "123abc"
    end
  end

  defmodule SpecPort do
    use ExUnit.Case

    test "Port to get date via date command" do
      _pid = Port.open({:spawn, "ls README.md"}, [:binary, :stderr_to_stdout, :exit_status])
      receive do
        received_data ->
          {_, port_data} = received_data
          assert {:data, "README.md\n"} === port_data
      end
      receive do
        received_data ->
          {_, port_data} = received_data
          assert {:exit_status, 0} === port_data
      end
      # assert [3, 4, 5, 6, 7, 8, 9, 10, 11, 12] === Enum.map range, &(&1 + 2)
    end
  end

  defmodule SpecAtom do
    use ExUnit.Case

    test "Is atom :foo" do
      assert is_atom(:foo) === true
    end
    test "Is atom :me@localhost" do
      assert is_atom(:me@localhost) === true
    end
    test "Is atom :\"with spaces\"" do
      assert is_atom(:"with spaces") === true
    end
    test "Is atom ':with spaces'" do
      assert is_atom(:'with spaces') === true
    end
    test "Is atom :<>" do
      assert is_atom(:'with spaces') === true
    end
    test "Is atom :===" do
      assert is_atom(:'with spaces') === true
    end
  end

  defmodule SpecTuple do
    use ExUnit.Case

    test "Is tuple {1, 2}" do
      assert is_tuple({1, 2}) === true
    end
    test "Is tuple {:ok, {:name, :\"elixir\"}}" do
      assert is_tuple({:ok, {:name, :"elixir"}}) === true
    end
    test "Is tuple {:error, :enoent}" do
      assert is_tuple({:error, :enoent}) === true
    end
    test "Pattern matching tuple {status, count, action} = {:ok, 42, \"next\"}" do
      {_status, _count, action} = {:ok, 42, "next"}
      assert action === "next"
    end
  end

  defmodule SpecRecord do
    use ExUnit.Case
    require Spec.RecordUser

    test "Create record" do
      assert {:user, "ryuone", :ok} === Spec.RecordUser.user
    end

    test "Create record with argument" do
      assert {:user, "ryuone", :not_ok} === Spec.RecordUser.user status: :not_ok
    end

    test "Get zero position value via elem function" do
      assert :user === Spec.RecordUser.user |> elem 0
    end

    test "Get second position value via elem function" do
      assert :ok === Spec.RecordUser.user |> elem 2
    end
  end

  defmodule SpecList do
    use ExUnit.Case

    test "Append via ++" do
      assert [1, 2, 3, 4, 1, 2, 3] === [1,2,3] ++ [4,1,2,3]
    end
    test "Remove via --" do
      assert [5,6,7] === [1,2,3,4,5,6,7] -- [4,1,2,3]
    end
  end

  defmodule SpecKeywordList do
    use ExUnit.Case

    test "Create keyword list" do
      assert [status: :ok, name: "ryuone"] === Keyword.new name: "ryuone", status: :ok
    end
    test "Get :name value from keyword list" do
      kwlist = Keyword.new name: "ryuone", status: :ok
      assert "ryuone" === kwlist |> Keyword.get :name
    end
    test "Get keylist from keyword list" do
      kwlist = Keyword.new name: "ryuone", status: :ok
      assert [:name, :status] === Keyword.keys kwlist |> Enum.sort
    end
    test "Get values from keyword list" do
      kwlist = Keyword.new name: "ryuone", status: :ok
      assert ["ryuone", :ok] === Keyword.values kwlist |> Enum.sort
    end
    test "Update value in keyword list" do
      kwlist = Keyword.new name: "ryuone", status: :ok
      assert [name: :ryuone, status: :ok] === Keyword.put kwlist, :name, :ryuone
    end
  end

  defmodule SpecMap do
    use ExUnit.Case

    test "Create map" do
      assert true === is_map(%{ "Tokyo" => "東京", "Osaka" => "大阪" })
    end
    test "Get value via string" do
      pref = %{ "Tokyo" => "東京", "Osaka" => "大阪" }
      assert pref["Osaka"] === "大阪"
    end
    test "Get value like property" do
      pref = %{ :tokyo => "東京", :osaka => "大阪" }
      assert pref.tokyo === "東京"
    end
    test "Get value nested" do
      type = %{ [name: "A"] => "Name A", [name: "B"] => "Name B" }
      assert type[[name: "A"]] === "Name A"
    end
    test "Pattern match map" do
      type = %{ [name: "A"] => "Name A", [name: "B"] => "Name B" }
      %{[name: "B"] => b} = type
      assert b === "Name B"
    end
    test "Update map" do
      pref = %{ :tokyo => "東京", :osaka => "大阪" }
      pref = %{ pref | :tokyo => "東京都" }
      assert pref.tokyo === "東京都"
    end
    test "Update map with not exist key" do
      pref = %{ :tokyo => "東京", :osaka => "大阪" }
      try do
        pref = %{ pref | :tokyo_to => "東京都" }
      rescue
        e in ArgumentError ->
          assert e === %ArgumentError{message: "argument error"}
      end
    end
  end

  defmodule SpecHashDict do
    use ExUnit.Case

    test "Create HashDict" do
      value = [ one: 1, two: 2, three: 3 ]
      assert 3 === value |> Enum.into(HashDict.new) |> HashDict.size
    end
    test "Get values" do
      value = [ one: 1, two: 2, three: 3 ]
      assert [1,2,3] === value |> Enum.into(HashDict.new) |> HashDict.values |> Enum.sort
    end
    test "Get keys" do
      value = [ one: 1, two: 2, three: 3 ]
      assert [:one, :three, :two] === value |> Enum.into(HashDict.new) |> HashDict.keys |> Enum.sort
    end
    test "Put value" do
      hd = [ one: 1, two: 2, three: 3 ] |> Enum.into(HashDict.new)
      assert [:four, :one, :three, :two] === HashDict.put(hd, :four, 4) |> HashDict.keys |> Enum.sort
    end
    test "Merge value" do
      hd1 = [ one: 1, two: 2, three: 3 ] |> Enum.into(HashDict.new)
      hd2 = [ four: 4, five: 5, six: 6 ] |> Enum.into(HashDict.new)
      assert [:five, :four, :one, :six, :three, :two] === HashDict.merge(hd1, hd2) |> HashDict.keys |> Enum.sort
      assert [1, 2, 3, 4, 5, 6] === HashDict.merge(hd1, hd2) |> HashDict.values |> Enum.sort
    end
  end

  defmodule SpecHashSet do
    use ExUnit.Case

    test "Create HashSet" do
      hashset = Enum.into 1..5, HashSet.new
      assert [1,2,3,4,5] === HashSet.to_list(hashset) |> Enum.sort
    end
    test "HashSet union" do
      hashset1 = Enum.into 1..3, HashSet.new
      hashset2 = Enum.into 2..6, HashSet.new
      assert [1,2,3,4,5,6] === HashSet.union(hashset1, hashset2) |> HashSet.to_list |> Enum.sort
    end
    test "HashSet member?" do
      hashset = Enum.into 1..3, HashSet.new
      assert true === HashSet.member? hashset, 3
    end
    test "HashSet difference" do
      hashset1 = Enum.into 1..5, HashSet.new
      hashset2 = Enum.into 4..10, HashSet.new
      assert [1,2,3] === HashSet.difference(hashset1, hashset2) |> HashSet.to_list |> Enum.sort
      assert [6, 7, 8, 9, 10] === HashSet.difference(hashset2, hashset1) |> HashSet.to_list |> Enum.sort
    end
    test "HashSet intersection" do
      hashset1 = Enum.into 1..5, HashSet.new
      hashset2 = Enum.into 4..10, HashSet.new
      assert [4,5] === HashSet.intersection(hashset1, hashset2) |> HashSet.to_list |> Enum.sort
    end
  end

  defmodule SpecBinary do
    use ExUnit.Case

    test "binary string" do
      assert "ABab" === <<65, 66, 97, 98>>
    end
    test "binary string using size" do
      assert <<213>> === <<3 :: size(2), 5 :: size(4), 1 :: size(2)>>
    end
    test "binary string pattern match" do
      <<_hello::binary-size(5), rest::binary>> = "Hello world"
      assert rest === " world"
    end
  end

  defmodule SpecStruct do
    use ExUnit.Case

    test "Create struct" do
      user = %Spec.StructUser{name: "ryuone"}
      assert user.name === "ryuone"
      assert user.status === :dont_know
      assert user.__struct__ === Spec.StructUser
    end
    test "Can not access like Hash" do
      user = %Spec.StructUser{name: "ryuone"}
      try do
        user[:name]
      rescue
        e in Protocol.UndefinedError ->
          assert e === %Protocol.UndefinedError{description: nil, protocol: Access, value: %Spec.StructUser{name: "ryuone", status: :dont_know}}
      end
    end
    test "Can not use Dict" do
      user = %Spec.StructUser{name: "ryuone"}
      try do
        Dict.get(user, :name)
      rescue
        e in UndefinedFunctionError ->
          assert e === %UndefinedFunctionError{arity: 3, function: :get, module: Spec.StructUser,self: false}
      end
    end
    test "Update struct(like Map)" do
      user = %Spec.StructUser{name: "ryuone"}
      assert %Spec.StructUser{name: "ryuone", status: :fine} === %{user | status: :fine}
    end
  end

  defmodule SpecProtocols do
    use ExUnit.Case

    test "Name is blank in %Spec.StructUser" do
      assert true === Spec.Blank.blank? %Spec.StructUser{}
    end
    test "Name is not blank in %Spec.StructUser?" do
      assert false === Spec.Blank.blank? %Spec.StructUser{name: "ryuone"}
    end
  end
end
