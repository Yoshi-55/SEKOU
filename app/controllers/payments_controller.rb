class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_job, only: [:new, :create]
  before_action :authorize_client!, only: [:new, :create]

  def new
    if @job.published? || @job.closed?
      redirect_to @job, alert: 'この案件は既に掲載済みです。'
      return
    end

    @payment = @job.payments.build
    @payment.base_price = 5000
    @payment.featured_price = @job.featured? ? 3000 : 0
    @payment.urgent_price = @job.urgent? ? 2000 : 0
    @payment.extended_price = @job.extended_period? ? 3000 : 0
  end

  def create
    @payment = @job.payments.build(payment_params)
    @payment.calculate_amount

    begin
      # Stripe Checkoutセッションを作成
      session = Stripe::Checkout::Session.create({
        payment_method_types: ['card'],
        line_items: build_line_items,
        mode: 'payment',
        success_url: payment_url(id: 'CHECKOUT_SESSION_ID') + '?session_id={CHECKOUT_SESSION_ID}',
        cancel_url: new_payment_url(job_id: @job.id),
        client_reference_id: @job.id.to_s,
        metadata: {
          job_id: @job.id,
          user_id: current_user.id
        }
      })

      @payment.stripe_session_id = session.id
      @payment.save!

      # Stripe Checkoutページにリダイレクト
      redirect_to session.url, allow_other_host: true
    rescue Stripe::StripeError => e
      flash[:alert] = "決済処理でエラーが発生しました: #{e.message}"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    session_id = params[:session_id] || params[:id]

    begin
      session = Stripe::Checkout::Session.retrieve(session_id)
      @payment = Payment.find_by(stripe_session_id: session_id)

      if @payment.nil?
        flash[:alert] = '決済情報が見つかりません。'
        redirect_to root_path
        return
      end

      @job = @payment.job

      # 決済成功の場合
      if session.payment_status == 'paid' && @payment.pending?
        @payment.mark_as_succeeded!(session.payment_intent)
        @job.publish!
        flash.now[:notice] = '決済が完了しました。案件が公開されました。'
      end
    rescue Stripe::StripeError => e
      flash[:alert] = "決済確認でエラーが発生しました: #{e.message}"
      redirect_to root_path
    end
  end

  private

  def set_job
    @job = Job.find(params[:job_id])
  end

  def authorize_client!
    unless current_user.is_a?(Client) && @job.client == current_user
      redirect_to root_path, alert: 'アクセス権限がありません。'
    end
  end

  def payment_params
    params.require(:payment).permit(:base_price, :featured_price, :urgent_price, :extended_price)
  end

  def build_line_items
    items = []

    # 基本掲載料
    items << {
      price_data: {
        currency: 'jpy',
        product_data: {
          name: '案件掲載料（基本）',
          description: '30日間の掲載'
        },
        unit_amount: 5000
      },
      quantity: 1
    }

    # 注目表示
    if @job.featured?
      items << {
        price_data: {
          currency: 'jpy',
          product_data: {
            name: '注目表示オプション',
            description: '案件一覧で目立つ位置に表示'
          },
          unit_amount: 3000
        },
        quantity: 1
      }
    end

    # 急募タグ
    if @job.urgent?
      items << {
        price_data: {
          currency: 'jpy',
          product_data: {
            name: '急募タグオプション',
            description: '急募バッジの表示'
          },
          unit_amount: 2000
        },
        quantity: 1
      }
    end

    # 掲載期間延長
    if @job.extended_period?
      items << {
        price_data: {
          currency: 'jpy',
          product_data: {
            name: '掲載期間延長オプション',
            description: '掲載期間を60日間に延長'
          },
          unit_amount: 3000
        },
        quantity: 1
      }
    end

    items
  end
end
