defmodule Autox.ChangesetView do
  defmacro __using__(_opts) do
    quote location: :keep do
      def render("error.json", %{changeset: changeset}) do
        # When encoded, the changeset returns its errors
        # as a JSON object. So we just pass it forward.
        %{errors: changeset.errors |> jsonapi}
      end

      def jsonapi(errors) do
        errors
        |> Enum.map(&format_each/1)
      end

      defp format_each({field, {message, vals}}) do
        message = Regex.replace(~r/%{count}/, message, "#{vals[:count]}")
        %{
          source: %{ pointer: pointer_for(field) },
          detail: message
        }
      end

      defp format_each({field, message}) do
        %{
          source: %{ pointer: pointer_for(field) },
          detail: message
        }
      end

      defp pointer_for(field) do
        "/data/attributes/#{field}"
      end
    end
  end
end