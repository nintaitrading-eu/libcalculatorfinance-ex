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

      # -minimum risk-
      iex> LibCalculatorFinance.Trading.calculate_risk_actual(4138.00, 4, 0.0, 3.0, 4151.30, 4, 0.0, 3.0, 117.4136, 53.20)
      117.4136
      # -bigger risk-
      iex> LibCalculatorFinance.Trading.calculate_risk_actual(4178.50, 4, 0.0, 3.0, 4144.50, 4, 0.0, 3.0, 119.4196, -136.0)
      142.0000

  """
  def calculate_risk_actual(a_price_buy, a_shares_buy, a_tax_buy, a_commission_buy, a_price_sell, a_shares_sell, a_tax_sell, a_commission_sell, a_risk_initial, a_profit_loss) do
    if (((a_profit_loss < 0.0) and (abs(a_profit_loss) < a_risk_initial)) or (a_profit_loss >= 0.0)) do
      a_risk_initial
    else
      a_shares_buy * a_price_buy * (1.0 + a_tax_buy / 100.0) - a_shares_sell * a_price_sell * (1.0 - a_tax_sell / 100.0) + a_commission_buy + a_commission_sell
    end
  end

end
