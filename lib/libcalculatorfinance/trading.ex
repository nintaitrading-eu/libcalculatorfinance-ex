################################################################
# See LICENSE.txt file for copyright and license info.
################################################################

################################################################
# Author: Andy Nagels
# Date: 2016-06-10
# Financial calculatations, specific to trading.
################################################################


defmodule LibCalculatorFinance.Trading do
  @moduledoc false

  @doc ~S"""
  calculate_risk_actual:
  Calculates the risk we actually took, based on the data in TABLE_TRADE.
  Note:
  -----
  risk_actual = S.Pb + S.Pb.T + Cb - (S.Ps - S.Ps.T - Cs)
  Note:
  -----
  It's the same for long and short.

  ## Examples

      iex> LibCalculatorFinance.Trading.calculate_risk_actual([])
      nil
      iex> LibCalculatorFinance.Trading.calculate_risk_actual([1,2,3,4,5])
      3.0
      iex> LibCalculatorFinance.Trading.calculate_risk_actual([1.5,-2.1,3,4.5,5])
      2.38

  """
  def calculate_risk_actual([]), do: nil
  def calculate_risk_actual(list) do
    Enum.sum(list) / Kernel.length(list)
  end

end
