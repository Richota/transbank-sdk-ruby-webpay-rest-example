
class WebpayController < ApplicationController

  skip_before_action :verify_authenticity_token
  def index
  end

  def create
  end

  def send_create
    buy_order = params[:buy_order]
    session_id = params[:session_id]
    amount = params[:amount]
    return_url = params[:return_url]
    @req = params.as_json
    @resp = Transbank::Webpay::WebpayPlus::Transaction::create(
                                                       buy_order: buy_order,
                                                       session_id: session_id,
                                                       amount: amount,
                                                       return_url: return_url
                                                      )
    render 'transaction_created'
  end

  def commit
    @req = params.as_json

    @token = params[:token_ws]
    @resp = Transbank::Webpay::WebpayPlus::Transaction::commit(token: @token)
    render 'transaction_committed'
  end

  def refund
    @req = params.as_json
    @token = params[:token]
    @amount = params[:amount]
    @resp = Transbank::Webpay::WebpayPlus::Transaction::refund(token: @token, amount: @amount)
  end

  def status
    @req = params.as_json
    @token = params[:token]
    @resp = Transbank::Webpay::WebpayPlus::Transaction::status(token: @token)
  end

  def mall_create
  end

  def send_mall_create
    params.permit!
    @req = params.as_json
    @buy_order = params[:buy_order]
    @session_id = params[:session_id]
    @return_url = params[:return_url]
    @details = params[:detail][:details].map(&:to_h)
    @resp = Transbank::Webpay::WebpayPlus::MallTransaction::create(
      buy_order: @buy_order,
      session_id: @session_id,
      return_url: @return_url,
      details: @details
    )
    render 'mall_transaction_created'
  end

  def mall_commit
    @req = params.as_json
    @resp = Transbank::Webpay::WebpayPlus::MallTransaction::commit(token: @req['token_ws'])

    render 'mall_transaction_committed'
  end

  def mall_status
    @token = params[:token]
    @resp = Transbank::Webpay::WebpayPlus::MallTransaction::status(token: @token)
    render 'webpay/mall_transaction_status'
  end

  def mall_refund
    @token = params[:token]
    @child_commerce_code = params[:commerce_code]
    @child_buy_order = params[:buy_order]
    @child_amount = params[:amount]
    @resp = Transbank::Webpay::WebpayPlus::MallTransaction::refund(token: @token,
                                                                   buy_order: @child_buy_order,
                                                                   child_commerce_code: @child_commerce_code,
                                                                   amount: @child_amount)
    render 'webpay/mall_transaction_refunded'
  end

end
