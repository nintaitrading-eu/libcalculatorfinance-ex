################################################################
# See LICENSE.txt file for copyright and license info.
################################################################

################################################################
# Author: Andy Nagels
# Date: 2016-06-10
# Financial calculatations, specific to trading.
################################################################


defmodule LibCalculatorFinance.General do
  @moduledoc false

  @doc ~S"""
  version:
  Returns the version string of the LibCalculatorFinance library.

  ## Examples

      iex> LibCalculatorFinance.General.version
      "0.0.0.1"

  """
  def version do
    # TODO: get this from a general place?
    "0.0.0.1"
  end

  @doc ~S"""
  calculate_percentage_of:
  Calculate what percentage a_value is from a_from_value.

  ## Examples
      iex> LibCalculatorFinance.General.calculate_percentage_of(2.0, 50.0)
      4.0
  """
  def calculate_percentage_of(a_value, a_from_value) do
    a_value / a_from_value * 100.0
  end

  @doc ~S"""
  convert_from_orig:
  Returns a price, with an exchange rate applied to it.

  ## Examples
      iex> LibCalculatorFinance.General.convert_from_orig(12.0, 0.5)
      6.0
  """
  def convert_from_orig(a_price, a_exchange_rate) do
    a_price * a_exchange_rate
  end

  @doc ~S"""
  convert_to_orig:
  Returns a price, in the original currency, with the exchange rate no longer applied to it.

  ## Examples
      iex> LibCalculatorFinance.General.convert_to_orig(6.0, 0.5)
      12.0
  """
  def convert_to_orig(a_converted_price, a_exchange_rate) do
    a_converted_price / a_exchange_rate
  end

  @doc ~S"""
  calculate_leveraged_contracts:
  Calculates the number of contracts to buy, according to an algorithm that determines an ideal amount of leverage.
  
  ## Examples
      iex> LibCalculatorFinance.General.calculate_leveraged_contracts(4.0)
      5.0
  """
  def calculate_leveraged_contracts(a_n) do
    Float.ceil(a_n / 3.0) - 1 + a_n
  end

end
