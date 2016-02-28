defmodule SpecTest do
  use ExUnit.Case

  defmodule SpecRange do
    use ExUnit.Case

    test "1..10 and Enum.map +1" do
      assert Spec.Range.from_3_to_12 === [3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    end
  end

  defmodule SpecRegEx do
    use ExUnit.Case

    test "Regex digit" do
      assert Spec.Regex.regex_digit("123abc") === ["123", "123"]
    end
  end

  defmodule SpecPort do
    use ExUnit.Case

    test "Port to get date via date command" do
      assert Spec.Port.exec === {{:data, "README.md\n"}}
    end
  end

  defmodule SpecAtom do
    use ExUnit.Case

    test "Is atom :foo" do
      assert is_atom(Spec.Atom.atom_foo) === true
    end
    test "Is atom :me@localhost" do
      assert is_atom(Spec.Atom.atom_include_atmark) === true
    end
    test "Is atom :\"with spaces\"" do
      assert is_atom(Spec.Atom.atom_with_spaces_double_quote) === true
    end
    test "Is atom ':with spaces'" do
      assert is_atom(Spec.Atom.atom_with_spaces_single_quote) === true
    end
    test "Is atom :<>" do
      assert is_atom(Spec.Atom.atom_inequality) === true
    end
    test "Is atom :===" do
      assert is_atom(Spec.Atom.atom_equality) === true
    end
  end

  defmodule SpecTuple do
    use ExUnit.Case

    test "Is tuple {1, 2}" do
      assert is_tuple(Spec.Tuple.normal) === true
    end
    test "Is tuple {:ok, {:name, :\"elixir\"}}" do
      assert is_tuple(Spec.Tuple.tuple_with_ok) === true
    end
    test "Is tuple {:error, :enoent}" do
      assert is_tuple(Spec.Tuple.tuple_with_error) === true
    end
    test "Pattern matching tuple {status, count, action} = {:ok, 42, \"next\"}" do
      {_status, _count, action} = Spec.Tuple.tuple_with_status
      assert action === "next"
    end
  end

  defmodule SpecList do
    use ExUnit.Case

    test "Append via ++" do
      assert Spec.List.append([1,2,3], [4,1,2,3]) === [1, 2, 3, 4, 1, 2, 3]
    end
    test "Remove via --" do
      assert Spec.List.remove([1,2,3,4,5,6,7], [4,1,2,3]) === [5,6,7]
    end
  end

  defmodule SpecKeywordList do
    use ExUnit.Case

    test "Create keyword list" do
      assert Spec.Keywordlist.new name: "ryuone", status: :ok === [status: :ok, name: "ryuone"]
    end
    test "Get :name value from keyword list" do
      kwlist = Spec.Keywordlist.new name: "ryuone", status: :ok
      assert "ryuone" === kwlist |> Spec.Keywordlist.get(:name)
    end
    test "Get keylist from keyword list" do
      kwlist = Spec.Keywordlist.new name: "ryuone", status: :ok
      assert [:name, :status] === kwlist |> Keyword.keys |> Enum.sort
    end
    test "Get values from keyword list" do
      kwlist = Spec.Keywordlist.new name: "ryuone", status: :ok
      assert [:ok, "ryuone"] === kwlist |> Spec.Keywordlist.values |> Enum.sort
    end
    test "Update value in keyword list" do
      kwlist = Spec.Keywordlist.new name: "ryuone", status: :ok
      assert [name: :ryuone, status: :ok] === kwlist |> Spec.Keywordlist.put(:name, :ryuone)
    end
  end

  defmodule SpecMap do
    use ExUnit.Case

    test "Create map" do
      assert true === Spec.Map.new |> is_map
    end
    test "Get value via string" do
      pref = Spec.Map.new
      assert pref["Osaka"] === "大阪"
    end
    test "Get value like property" do
      pref = Spec.Map.new_atom_key
      assert pref.tokyo === "東京"
    end
    test "Get value nested" do
      type = Spec.Map.new_list_key
      assert type[[name: "A"]] === "Name A"
    end
    test "Pattern match map" do
      %{[name: "B"] => b} = Spec.Map.new_list_key
      assert b === "Name B"
    end
    test "Update map" do
      pref = Spec.Map.new_atom_key |> Spec.Map.update_tokyo("東京都")
      assert pref.tokyo === "東京都"
    end
    test "Update map with Dict module" do
      pref = Spec.Map.new_atom_key |> Spec.Map.update(:tokyo, "東京都")
      assert pref.tokyo === "東京都"
    end
    test "Update map with not exist key" do
      pref = Spec.Map.new_atom_key
      try do
        _pref = %{ pref | :tokyo_to => "東京都" }
      rescue
        e in KeyError ->
          assert e === %KeyError{key: :tokyo_to, term: nil}
      end
    end
    test "Update map with not exist key and Dict module" do
      _pref = Spec.Map.new_atom_key
      try do
        __pref = Spec.Map.new_atom_key |> Spec.Map.update(:tokyo_to, "東京都")
      rescue
        e in KeyError ->
          assert e === %KeyError{key: :tokyo_to, term: nil}
      end
    end
  end

  defmodule SpecBinary do
    use ExUnit.Case

    test "binary string" do
      assert "ABab" === Spec.Binary.bin1
    end
    test "binary string using size" do
      assert <<213>> === Spec.Binary.bin2
    end
    test "binary string pattern match" do
      assert " world" === "Hello world" |> Spec.Binary.bin_match(5)
    end
  end

  defmodule SpecStruct do
    use ExUnit.Case

    test "Create struct" do
      user = Spec.StructUser.new "ryuone"
      assert user.name === "ryuone"
      assert user.status === :dont_know
      assert user.__struct__ === Spec.StructUser
    end
    test "Can not access like Hash" do
      user = Spec.StructUser.new "ryuone"
      try do
        user[:name]
      rescue
        e in UndefinedFunctionError ->
          assert e === %UndefinedFunctionError{arity: 2, function: :fetch, module: Spec.StructUser, reason: "Spec.StructUser does not implement the Access behaviour"}
      end
    end
    test "Can not use Dict" do
      user = Spec.StructUser.new "ryuone"
      try do
        Dict.get(user, :name)
      rescue
        e in UndefinedFunctionError ->
          assert e === %UndefinedFunctionError{arity: 3, function: :get, module: Spec.StructUser, reason: nil}
      end
    end
    test "Update struct(like Map)" do
      user = Spec.StructUser.new "ryuone"
      assert Spec.StructUser.new("ryuone", :fine) === Spec.StructUser.update(user, status: :fine)
    end
  end

  defmodule SpecProtocols do
    use ExUnit.Case

    test "Name is blank in %Spec.StructUser" do
      assert true === Spec.ProtocolBlank.blank? %Spec.StructUser{}
    end
    test "Name is not blank in %Spec.StructUser?" do
      assert false === Spec.ProtocolBlank.blank? %Spec.StructUser{name: "ryuone"}
    end
  end
end
