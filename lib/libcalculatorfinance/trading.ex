################################################################
# See LICENSE.txt file for copyright and license info.
################################################################

################################################################
# Author: Andy Nagels
# Date: 2016-06-10
# Financial calculatations, specific to trading.
################################################################


defmodule LibCalculatorFinance.Trading.BeforeTrade do
  @moduledoc false

  @doc ~S"""
  calculate_shares_recommended:
  Calculates the recommended amount of shares you can buy.

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_shares_recommended(10000.00, 1.0, 3.0, 12.0)
      808
  """
  def calculate_shares_recommended(a_pool, a_commission, a_tax, a_price) do
    # Note: Round convert the float result to an int.
    round(Float.floor((a_pool - (a_tax / 100.0 * a_pool) - a_commission) / a_price))
  end

  @doc ~S"""
  calculate_stoploss:
  Calculates the stoploss.
  Note
  ----
  Long:
  amount selling at stoploss - amount at buying = initial risk of pool
  (S.Pb + S.Pb.T + C) - (S.Ps - S.Ps.T - C) = R/100 * pool

  Short:
  amount selling - amount buying at stoploss = initial risk of pool
  (S.Psl + S.Psl.T + C) - (S.Ps - S.Ps.T - C) = R/100 * pool


  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_stoploss(12.0, 2, 3.0, 1.0, 2.0, 10000.0, true)
      109.00492610837439
      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_stoploss(12.0, 2, 3.0, 1.0, 2.0, 10000.0, false)
      -87.95939086294416
  """
  def calculate_stoploss(a_price, a_shares, a_tax, a_commission, a_risk, a_pool, a_is_long) do
      if not a_is_long do
        (a_shares * a_price * (1.0 + a_tax / 100.0) - a_risk / 100.0 * a_pool + 2.0 * a_commission) /
        (a_shares * 1.0 - a_tax / 100.0)
      else
        (a_risk / 100.0 * a_pool + a_shares * a_price * (1.0 - a_tax / 100.0) - 2.0 * a_commission) /
        (a_shares * 1.0 + a_tax / 100.0)
      end
  end

  @doc ~S"""
  calculate_risk_input:
  Calculates the risk based on total pool and input.
  Consider this the theoretical risk we want to take.

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_risk_input(10000.00, 2.0)
      200.0
  """
  def calculate_risk_input(a_pool, a_risk) do
    a_risk / 100.0 * a_pool
  end

end

defmodule LibCalculatorFinance.Trading.AfterTrade do
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
      iex> LibCalculatorFinance.Trading.AfterTrade.calculate_risk_actual(4138.00, 4, 0.0, 3.0, 4151.30, 4, 0.0, 3.0, 117.4136, 53.20)
      117.4136
      # -bigger risk-
      iex> LibCalculatorFinance.Trading.AfterTrade.calculate_risk_actual(4178.50, 4, 0.0, 3.0, 4144.50, 4, 0.0, 3.0, 119.4196, -136.0)
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
