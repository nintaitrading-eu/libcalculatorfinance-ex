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

end
