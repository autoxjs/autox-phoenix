ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Dummy.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Dummy.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Dummy.Repo)

