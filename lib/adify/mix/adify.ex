defmodule Mix.Tasks.Adify do
  @shortdoc ~s(Runs Adify task with given options)

  @task ~s(mix adify)

  @info """
  #{@task} runs adify commands:

  Usage:
      $ `@{task} --os osx

  Options:

  Option         Alias        Description
  --------------------------------------------------------------------------

  --os          NO-ALIAS      The Operating System on which Adify needs to run.
                              Can be one of either supporting os's. To get a
                              list of all supporting OS's run:
                              `$ mix adify.list_os`

  --noconfirm   NO-ALIAS      Determines whether there needs to be a
                              confirmation before installing each tool

  --tools-dir      -t         Path to the Tools Directory. Check out docs to
                              get the template of tools directory expected by
                              Adify

  --digest-file    -d         Path to where the Digest file will be generated
                              after Adification.
  """

  @moduledoc """
  This tasks run an adification process.

  It makes calls to Adify module to run the process with given inputs

  ## Info:

  #{@info}
  """

  use Mix.Task

  @switches [
    digest_file: :string,
    help: :boolean,
    noconfirm: :boolean,
    os: :string,
    tools_dir: :string
  ]

  @aliases [
    d: :digest_file,
    h: :help,
    t: :tools_dir
  ]

  @impl true
  def run(args) do
    {parsed, _args, _} = OptionParser.parse(args, switches: @switches, aliases: @aliases)

    case parsed[:help] do
      true ->
        print_help()

      _ ->
        parsed
        |> prep_opts()
        |> Adify.run()
    end
  end

  defp print_help do
    Mix.Shell.IO.info("""
    #{@shortdoc}

    #{@info}
    """)
  end

  defp prep_opts(adify_opts) do
    [confirm: !Keyword.get(adify_opts, :noconfirm, false)]
    |> Keyword.merge(adify_opts)
  end
end
