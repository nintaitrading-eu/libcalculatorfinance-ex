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

  @doc ~S"""
  calculate_risk_initial:
  Calculates the initial risk.
  This is the risk we will take if our stoploss is reached.
  This should be equal to the risk_input if everything was
  correctly calculated.
  Note
  ----
  Long:
  S.Pb + S.Pb.T + C - (S.Psl - S.Psl.T - C)
  Short:
  S.Ps + S.Psl.T + C - (S.Ps - S.Ps.T - C)

  ## Examples

      iex> Float.round(LibCalculatorFinance.Trading.BeforeTrade.calculate_risk_initial(12.0, 2, 3.0, 1.0, 10.0, true), 6)
      7.320000
      iex> Float.round(LibCalculatorFinance.Trading.BeforeTrade.calculate_risk_initial(12.0, 2, 3.0, 1.0, 10.0, false), 6)
      -0.680000
  """
  def calculate_risk_initial(a_price, a_shares, a_tax, a_commission, a_stoploss, a_is_long) do
    if a_is_long do
      a_shares * a_price * (1.0 + a_tax / 100.0) - a_shares * a_stoploss * (1.0 - a_tax / 100.0) + 2.0 * a_commission
    else
      a_shares * a_stoploss * (1.0 + a_tax / 100.0) - a_shares * a_price * (1.0 - a_tax / 100.0) + 2.0 * a_commission
    end
  end

  @doc ~S"""
  calculate_amount:
  Calculates the amount withouth tax and commission.

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_amount(12.0, 2)
      24.0
  """
  def calculate_amount(a_price, a_shares) do
    a_price * a_shares
  end

  @doc ~S"""
  calculate_amount_with_tax_and_commission:
  Calculates the amount with tax and commission.
  Note:
  -----
  AMT = S.P + S.P.T + C (buy)
  AMT = S.P - S.P.T - C (sell)

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_amount_with_tax_and_commission(12.0, 2, 3.0, 1.0, :buy)
      97.0
      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_amount_with_tax_and_commission(12.0, 2, 3.0, 1.0, :sell)
      -49.0
  """
  def calculate_amount_with_tax_and_commission(a_price, a_shares, a_tax, a_commission, a_transaction_type) do
    if a_transaction_type == :buy do
      a_shares * a_price + a_shares * a_price * a_tax + a_commission
    else
      a_shares * a_price - a_shares * a_price * a_tax - a_commission
    end
  end

  @doc ~S"""
  calculate_amount_with_tax:
  Calculates the amount (buy/sell) with tax included, but not the commission.
  Note:
  -----
  profit_loss = S.P + S.P.T (buy)
  profit_loss = S.P - S.P.T (sell)

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_amount_with_tax(12.0, 2, 3.0, :buy)
      23.28
      iex> LibCalculatorFinance.Trading.BeforeTrade.calculate_amount_with_tax(12.0, 2, 3.0, :sell)
      24.72
  """
  def calculate_amount_with_tax(a_price, a_shares, a_tax, a_transaction_type) do
    if a_transaction_type == :buy do
      a_shares * a_price * (1.0 - a_tax / 100.0)
    else
      a_shares * a_price * (1.0 + a_tax / 100.0)
    end
  end

  @doc ~S"""
  cost_transaction:
  Cost of transaction (tax and commission).

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.cost_transaction(12.0, 2, 3.0, 1.0)
      1.72
  """
  def cost_transaction(a_price, a_shares, a_tax, a_commission) do
    a_price * a_shares * a_tax / 100.0 + a_commission
  end

  @doc ~S"""
  cost_tax:
  Cost of tax (buy and sell).

  ## Examples

      iex> LibCalculatorFinance.Trading.BeforeTrade.cost_tax(25.75, 1.0, 2, 12.0, :buy)
      0.75
      iex> LibCalculatorFinance.Trading.BeforeTrade.cost_tax(22.25, 1.0, 2, 12.0, :sell)
      0.75
  """
  def cost_tax(a_amount, a_commission, a_shares, a_price, a_transaction_type) do
    if a_transaction_type == :sell do
      - a_amount - a_commission + a_shares * a_price
    else
      a_amount - a_shares * a_price - a_commission
    end
  end

  @doc ~S"""
  calculate_price:
  Calculates the price when buying or selling.

  ## Examples

      iex> Float.round(LibCalculatorFinance.Trading.BeforeTrade.calculate_price(24.0, 2, 3.0, 1.0, :buy), 6)
      11.165049
      iex> Float.round(LibCalculatorFinance.Trading.BeforeTrade.calculate_price(24.0, 2, 3.0, 1.0, :sell), 6)
      12.886598
  """
  def calculate_price(a_amount, a_shares, a_tax, a_commission, a_transaction_type) do
    if a_transaction_type == :buy do
      (a_amount - a_commission) / ((1.0 + a_tax / 100.0) * a_shares)
    else
      (a_amount + a_commission) / ((1.0 - a_tax / 100.0) * a_shares)
    end
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

  @doc ~S"""
  calculate_r_multiple:
  Function to calculate the R-multiple.

  ## Examples

      iex> Float.round(LibCalculatorFinance.Trading.AfterTrade.calculate_r_multiple(-100.0, 200.0), 6)
      -0.5
  """
  def calculate_r_multiple(a_profit_loss, a_risk_initial) do
    a_profit_loss / a_risk_initial
  end

  @doc ~S"""
  calculate_cost_total:
  Function to calculate the total cost associated with the given trade.

  ## Examples

      iex> Float.round(LibCalculatorFinance.Trading.AfterTrade.calculate_cost_total(100.0, 3.0, 1.0, 50.0, 3.0, 1.0), 6)
      6.5
  """
  def calculate_cost_total(a_amount_buy, a_tax_buy, a_commission_buy,
    a_amount_sell, a_tax_sell, a_commission_sell) do
    a_tax_buy / 100.0 * a_amount_buy + a_commission_buy + a_tax_sell / 100.0 * a_amount_sell + a_commission_sell
  end

  @doc ~S"""
  calculate_profit_loss:
  Calculates the profit_loss, without taking tax and commission into account.
  Note:
  -----
  profit_loss = S.Ps - S.Pb
  => it's the same for long and short

  ## Examples

      iex> Float.round(LibCalculatorFinance.Trading.AfterTrade.calculate_profit_loss(12.0, 2, 24.0, 2), 6)
      24.0
  """
  def calculate_profit_loss(a_price_buy, a_shares_buy, a_price_sell, a_shares_sell) do
    a_shares_sell * a_price_sell - a_shares_buy * a_price_buy
  end
end
