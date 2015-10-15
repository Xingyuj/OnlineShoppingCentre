class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy, :check_out, :pay, :approval, :update_reject_status, :refund, :reject, :confirm, :ship]
  before_action :authenticate_user!

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  # create a new order
  def new
    @order = Order.new
    @product_params = {amount: params["amount"], product_id: params["productId"]}
    render :new
  end

  # POST /orders
  # POST /orders.json
  # save one order in the database
  def create
    attributes = {"current_user_id" => current_user.id}
    request_params = order_params
    attributes.merge! request_params
    @order = Order.new(attributes)
    signal = @order.save_order
    respond_to do |format|
      if signal
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /orders/1/edit
  def edit
  end

  # render the view to let the user enter the information about the order
  def new_cart_orders
    @order = Order.new
    session[:selected_cart_products] = params[:cart_product_ids]
  end

  # create orders for selected items in the cart
  def create_cart_orders
    cart_order_params = params.permit(:name, :postcode, :address, :phone, :product_id, :amount, :current_user_id)
    message = Order.create_cart_orders session[:selected_cart_products], current_user.id, cart_order_params
    if message.instance_of? Array
      session[:orders_generated] = message
      respond_to do |format|
        format.html { render create_cart_orders_orders_path, notice: 'Orders was successfully created.' }
      end
    else
      respond_to do |format|
        format.html { render show_cart_cart_products_path, notice: message }
      end
    end
  end

  def check_out
  end

  # pay for one order
  def pay_for_orders
    orders_selected = session[:orders_generated]
    orders_selected.each do |order|
      order_generated = Order.find order
      order_generated.update_attribute(:status, "Paid")
    end
  end

  def pay
    @order.update_attribute(:status, "Paid")
    render :pay_for_orders
  end

  # show the information of one order
  def show_order
    @orders = Order.show_order(params[:type], params[:page], current_user.id)
    type = params["type"]
    if type.to_s == 'purchase'
      render :show_purchase_order
      return
    elsif type == "sell"
      render :show_sell_order
      return
    end
  end

  def approval
    @order.status = "Cancelled"
    respond_to do |format|
      if @order.save
        format.html { redirect_to request_manager_orders_path, notice: 'Requested Order was successfully approvaled.' }
        format.json { redirect_to request_manager_orders_path, status: :ok, location: @order }
      else
        format.html { redirect_to request_manager_orders_path }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_reject_status
    @order
  end

  def reject
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to request_manager_orders_path, notice: 'Status of Requested Order was successfully modofied.' }
        format.json { redirect_to request_manager_orders_path, status: :ok, location: @order }
      else
        format.html { redirect_to request_manager_orders_path }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end
  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def request_manager
    if current_user.has_role? :admin
      @requested_orders = Order.show_order('revoke', params[:page], current_user.id)
    else
      render :has_no_perimission
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  # delete one order
  def destroy
    @order.destroy
    respond_to do |format|
      @orders = Order.show_order("purchase", params[:page], current_user.id)
      format.html { render :show_purchase_order, notice: 'Refund request was successfully created.' }
      format.json { render :show_purchase_order, status: :ok, location: @order }
    end
  end

  def refund
    @order.status = "Pending"
    respond_to do |format|
      if @order.save
        @orders = Order.show_order("purchase", params[:page], current_user.id)
        format.html { render :show_purchase_order, notice: 'Refund request was successfully created.' }
        format.json { render :show_purchase_order, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end

  end

  def confirm
    @order.status = "Received"
    respond_to do |format|
      if @order.save
        @orders = Order.show_order("purchase", params[:page], current_user.id)
        format.html { render :show_purchase_order, notice: 'Refund request was successfully created.' }
        format.json { render :show_purchase_order, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  def ship
    @order.status = "Shipped"
    respond_to do |format|
      if @order.save
        @orders = Order.show_order("sell", params[:page], current_user.id)
        format.html { render :show_sell_order, notice: 'Refund request was successfully created.' }
        format.json { render :show_sell_order, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:buyer_id, :seller_id, :status, :total_price, :postcode, :address, :phone, :product_id, :amount, :current_user_id)
    end
end
