defmodule ExMaybe do
  @moduledoc """
  This library fills a bunch of important niches.
  A Maybe can help you with optional arguments,
  error handling, and records with optional fields.
  """

  @type t(value) :: value | nil
  @type result(error, value) :: {:error, error} | {:ok, value}

  @doc """
  Transform a Maybe value with a given function.

  ## Examples

      iex> ExMaybe.map(nil, fn(_) -> "TEST" end)
      nil

      iex> ExMaybe.map(10, fn(val) -> val + 1 end)
      11
  """
  @spec map(t(a), (a -> b)) :: t(b) when a: var, b: var
  def map(nil, _fun) do
    nil
  end

  def map(maybe, fun) do
    fun.(maybe)
  end

  @doc """
  Provide a default value, turning an optional value into a normal value.

  ## Examples

      iex> ExMaybe.with_default(nil, 10)
      10

      iex> ExMaybe.with_default(11, 20)
      11
  """
  @spec with_default(t(a), a) :: a when a: var
  def with_default(nil, default) do
    default
  end

  def with_default(maybe, _default) do
    maybe
  end

  @doc """
  Convert *result* to *maybe.*

  ## Examples

      iex> ExMaybe.from_result({:ok, 10})
      10

      iex> ExMaybe.from_result({:error, "Error message!!!"})
      nil
  """
  @spec from_result(result(any(), a)) :: t(a) when a: var
  def from_result({:ok, value}), do: value
  def from_result({:error, _}), do: nil
end
